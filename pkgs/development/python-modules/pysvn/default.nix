{
  stdenv,
  lib,
  buildPythonPackage,
  fetchurl,
  python,
  apr,
  aprutil,
  bash,
  e2fsprogs,
  expat,
  gcc,
  neon,
  glibcLocales,
  openssl,
  pycxx,
  subversion,
}:

buildPythonPackage rec {
  pname = "pysvn";
  version = "1.9.22";
  format = "other";

  src = fetchurl {
    url = "mirror://sourceforge/project/pysvn/pysvn/V${version}/pysvn-${version}.tar.gz";
    hash = "sha256-KfLg9tuuKpXxJoniD002kDXGCTwOZ9jurCoPrWMRo7g=";
  };

  patches = [ ./replace-python-first.patch ];

  buildInputs = [
    bash
    subversion
    apr
    aprutil
    expat
    neon
    openssl
  ] ++ lib.optionals stdenv.isLinux [ e2fsprogs ] ++ lib.optionals stdenv.isDarwin [ gcc ];

  preConfigure = ''
    cd Source
    ${python.pythonOnBuildForHost.interpreter} setup.py backport
    ${python.pythonOnBuildForHost.interpreter} setup.py configure \
      --apr-inc-dir=${apr.dev}/include \
      --apu-inc-dir=${aprutil.dev}/include \
      --pycxx-dir=${pycxx.dev}/include \
      --svn-inc-dir=${subversion.dev}/include/subversion-1 \
      --pycxx-src-dir=${pycxx.dev}/src \
      --apr-lib-dir=${apr.out}/lib \
      --svn-lib-dir=${subversion.out}/lib \
      --svn-bin-dir=${subversion.out}/bin
  '';

  nativeCheckInputs = [ glibcLocales ];

  checkPhase = ''
    runHook preCheck

    # It is not only shebangs, some tests also write scripts dynamically
    # so it is easier to simply search and replace
    sed -i "s|/bin/bash|${lib.getExe bash}|" ../Tests/test-*.sh
    make -C ../Tests

    runHook postCheck
  '';

  pythonImportsCheck = [ "pysvn" ];

  installPhase = ''
    dest=$(toPythonPath $out)/pysvn
    mkdir -p $dest
    cp pysvn/__init__.py $dest/
    cp pysvn/_pysvn*.so $dest/
    mkdir -p $out/share/doc
    mv -v ../Docs $out/share/doc/pysvn-${version}
    rm -v $out/share/doc/pysvn-${version}/generate_cpp_docs_from_html_docs.py
  '';

  meta = with lib; {
    description = "Python bindings for Subversion";
    homepage = "https://pysvn.sourceforge.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
    # g++: command not found
    broken = stdenv.isDarwin;
  };
}

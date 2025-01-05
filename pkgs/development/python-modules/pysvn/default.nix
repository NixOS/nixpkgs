{
  stdenv,
  lib,
  buildPythonPackage,
  fetchurl,
  python,
  apr,
  aprutil,
  bash,
  gcc,
  pycxx,
  subversion,
}:

buildPythonPackage rec {
  pname = "pysvn";
  version = "1.9.23";
  pyproject = false;

  src = fetchurl {
    url = "mirror://sourceforge/project/pysvn/pysvn/V${version}/pysvn-${version}.tar.gz";
    hash = "sha256-ABru1nng1RaYfZwe0Z0NxE90rU/J2h/BhzUnvgrasCk=";
  };

  patches = [ ./replace-python-first.patch ];

  buildInputs = [
    subversion
    apr
    aprutil
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ gcc ];

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
    broken = stdenv.hostPlatform.isDarwin;
  };
}

{ stdenv
, lib
, buildPythonPackage
, fetchurl
, isPy3k
, python
, apr
, aprutil
, bash
, e2fsprogs
, expat
, gcc
, glibcLocales
, neon
, openssl
, pycxx
, subversion
}:

buildPythonPackage rec {
  pname = "pysvn";
  version = "1.9.12";
  format = "other";

  src = fetchurl {
    url = "https://pysvn.barrys-emacs.org/source_kits/${pname}-${version}.tar.gz";
    sha256 = "sRPa4wNyjDmGdF1gTOgLS0pnrdyZwkkH4/9UCdh/R9Q=";
  };

  buildInputs = [ bash subversion apr aprutil expat neon openssl ]
    ++ lib.optionals stdenv.isLinux [ e2fsprogs ]
    ++ lib.optionals stdenv.isDarwin [ gcc ];

  postPatch = ''
    sed -i "117s|append(|insert(0, |" Tests/benchmark_diff.py
  '';

  preConfigure = ''
    cd Source
    ${python.interpreter} setup.py backport
    ${python.interpreter} setup.py configure \
      --apr-inc-dir=${apr.dev}/include \
      --apu-inc-dir=${aprutil.dev}/include \
      --pycxx-dir=${pycxx.dev}/include \
      --svn-inc-dir=${subversion.dev}/include/subversion-1 \
      --pycxx-src-dir=${pycxx.dev}/src \
      --apr-lib-dir=${apr.out}/lib \
      --svn-lib-dir=${subversion.out}/lib \
      --svn-bin-dir=${subversion.out}/bin
  '' + (lib.optionalString (stdenv.isDarwin && !isPy3k) ''
    sed -i -e 's|libpython2.7.dylib|lib/libpython2.7.dylib|' Makefile
  '');

  checkInputs = [ glibcLocales  ];
  checkPhase = ''
    runHook preCheck

    # It is not only shebangs, some tests also write scripts dynamically
    # so it is easier to simply search and replace
    sed -i "s|/bin/bash|${bash}/bin/bash|" ../Tests/test-*.sh
    make -C ../Tests

    ${python.interpreter} -c "import pysvn"

    runHook postCheck
  '';

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
    homepage = "http://pysvn.tigris.org/";
    license = licenses.asl20;
    # g++: command not found
    broken = stdenv.isDarwin;
  };
}

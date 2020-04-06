{ stdenv
, buildPythonPackage
, fetchFromGitiles
, isPy3k
}:

buildPythonPackage {
  pname = "gyp";
  version = "2015-06-11";
  disabled = isPy3k;

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/external/gyp";
    rev = "fdc7b812f99e48c00e9a487bd56751bbeae07043";
    sha256 = "1imgxsl4mr1662vsj2mlnpvvrbz71yk00w8p85vi5bkgmc6awgiz";
  };

  prePatch = stdenv.lib.optionals stdenv.isDarwin ''
    sed -i 's/raise.*No Xcode or CLT version detected.*/version = "7.0.0"/' pylib/gyp/xcode_emulation.py
  '';

  patches = stdenv.lib.optionals stdenv.isDarwin [
    ./no-darwin-cflags.patch
    ./no-xcode.patch
  ];

  meta = with stdenv.lib; {
    description = "A tool to generate native build files";
    homepage = https://chromium.googlesource.com/external/gyp/+/master/README.md;
    license = licenses.bsd3;
    maintainers = with maintainers; [ codyopel ];
  };

}

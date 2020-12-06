{ stdenv
, buildPythonPackage
, fetchFromGitiles
, isPy3k
}:

buildPythonPackage {
  pname = "gyp";
  version = "2020-05-12";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/external/gyp";
    rev = "caa60026e223fc501e8b337fd5086ece4028b1c6";
    sha256 = "0r9phq5yrmj968vdvy9vivli35wn1j9a6iwshp69wl7q4p0x8q2b";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [
    ./no-darwin-cflags.patch
    ./no-xcode.patch
  ];

  meta = with stdenv.lib; {
    description = "A tool to generate native build files";
    homepage = "https://chromium.googlesource.com/external/gyp/+/master/README.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ codyopel ];
  };

}

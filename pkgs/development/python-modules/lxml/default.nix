{ stdenv, lib, buildPythonPackage, fetchFromGitHub
, cython
, libxml2
, libxslt
, zlib
, xcodebuild
, fetchpatch
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "lxml-${version}";
    sha256 = "sha256-ppyLn8B0YFQivRCOE8TjKGdDDQHbb7UdTUkevznoVC8=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-2309.patch";
      url = "https://github.com/lxml/lxml/commit/86368e9cf70a0ad23cccd5ee32de847149af0c6f.patch";
      sha256 = "sha256-2NHESuG+a2hx+1369l0lSrlRENPgeLxqL18mzvufNh8=";
    })
  ];

  # setuptoolsBuildPhase needs dependencies to be passed through nativeBuildInputs
  nativeBuildInputs = [ libxml2.dev libxslt.dev cython ] ++ lib.optionals stdenv.isDarwin [ xcodebuild ];
  buildInputs = [ libxml2 libxslt zlib ];

  # tests are meant to be ran "in-place" in the same directory as src
  doCheck = false;

  pythonImportsCheck = [ "lxml" "lxml.etree" ];

  meta = with lib; {
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = "https://lxml.de";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer sjourdois ];
  };
}

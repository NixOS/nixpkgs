{ stdenv, lib, buildPythonPackage, fetchFromGitHub
, cython
, libxml2
, libxslt
, zlib
, xcodebuild
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.6.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1j3fqz44jc7dga1yyrdfkpn569al72jcs6bbhb7swq12wc8jwbnm";
  };

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

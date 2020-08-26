{ lib, buildPythonPackage, fetchFromGitHub
, cython
, libxml2
, libxslt
, zlib
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1d0cpwdjxfzwjzmnz066ibzicyj2vhx15qxmm775l8hxqi65xps4";
  };

  # setuptoolsBuildPhase needs dependencies to be passed through nativeBuildInputs
  nativeBuildInputs = [ libxml2.dev libxslt.dev cython ];
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

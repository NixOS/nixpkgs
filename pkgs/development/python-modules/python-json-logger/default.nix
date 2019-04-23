{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.1.10";
  pname = "python-json-logger";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf2caaf34bd2eff394915b6242de4d0245de79971712439380ece6f149748cde";
  };

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    homepage = https://github.com/madzak/python-json-logger;
    description = "A python library adding a json log formatter";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };

}

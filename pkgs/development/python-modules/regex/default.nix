{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2021.10.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26895d7c9bbda5c52b3635ce5991caa90fbb1ddfac9c9ff1c7ce505e2282fb2a";
  };

  # Sources for different Python releases are located in same folder
  checkPhase = ''
    rm -r ${if !isPy27 then "regex_2" else "regex_3"}
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "regex" ];

  meta = with lib; {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
    license = licenses.psfl;
    maintainers = with maintainers; [ abbradar ];
  };
}

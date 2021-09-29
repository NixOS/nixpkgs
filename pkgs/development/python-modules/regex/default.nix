{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2021.9.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ymb95XbhI1eyUJY1GqwrS4gLAGYmPnvHqaG0MHmRuw4=";
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

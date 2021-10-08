{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2021.9.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81e125d9ba54c34579e4539a967e976a3c56150796674aec318b1b2f49251be7";
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

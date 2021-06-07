{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "addic7ed-cli";
  version = "1.4.6";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "182cpwxpdybsgl1nps850ysvvjbqlnx149kri4hxhgm58nqq0qf5";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    pyquery
  ];

  # Tests require network access
  doCheck = false;
  pythonImportsCheck = [ "addic7ed_cli" ];

  meta = with lib; {
    description = "A commandline access to addic7ed subtitles";
    homepage = "https://github.com/BenoitZugmeyer/addic7ed-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ aethelz ];
    platforms = platforms.unix;
  };
}

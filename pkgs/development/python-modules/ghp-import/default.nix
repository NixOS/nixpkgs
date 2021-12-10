{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
}:

buildPythonPackage rec {
  pname = "ghp-import";
  version = "2.0.2";

  src = fetchFromGitHub {
     owner = "c-w";
     repo = "ghp-import";
     rev = "2.0.2";
     sha256 = "0i4lxsgqri1y8sw4k44bkwbzmdmk4vpmdi882mw148j8gk4i7vvj";
  };

  propagatedBuildInputs = [ python-dateutil ];

  # Does not include any unit tests
  doCheck = false;

  pythonImportsCheck = [ "ghp_import" ];

  meta = with lib; {
    description = "Copy your docs directly to the gh-pages branch";
    homepage = "https://github.com/c-w/ghp-import";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}

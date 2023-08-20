{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "jupyter-highlight-selected-word";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jcb91";
    repo = "jupyter_highlight_selected_word";
    rev = "refs/tags/${version}";
    hash = "sha256-KgM//SIfES46uZySwNR4ZOcolnJORltvThsmEvxXoIs=";
  };

  # This package does not have tests
  doChecks = false;

  pythonImportsCheck = [ "jupyter_highlight_selected_word" ];

  meta = with lib; {
    description = "Jupyter notebook extension that enables highlighting every instance of the current word in the notebook";
    homepage = "https://github.com/jcb91/jupyter_highlight_selected_word";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}

{ lib
, fetchPypi
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zsh-history-to-fish";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-expPuffZttyXNRreplPC5Ee/jfWAyOnmjTIMXONtrnw=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "zsh_history_to_fish"
  ];

  meta = with lib; {
    description = "Bring your ZSH history to Fish shell";
    homepage = "https://github.com/rsalmei/zsh-history-to-fish";
    license = licenses.mit;
    maintainers = with maintainers; [ alanpearce ];
    mainProgram = "zsh-history-to-fish";
  };
}

{
  lib,
  fetchPypi,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zsh-history-to-fish";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-expPuffZttyXNRreplPC5Ee/jfWAyOnmjTIMXONtrnw=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    click
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "zsh_history_to_fish"
  ];

  patches = [
    # Patch from currently-unmerged PR, fixing runtime error.
    # Should be removed when PR is merged or error is otherwise fixed.
    # Check https://github.com/rsalmei/zsh-history-to-fish/pull/15 if you're in the future
    ./fix-runtime-error.patch
  ];

  meta = with lib; {
    description = "Bring your ZSH history to Fish shell";
    homepage = "https://github.com/rsalmei/zsh-history-to-fish";
    license = licenses.mit;
    maintainers = with maintainers; [ alanpearce ];
    mainProgram = "zsh-history-to-fish";
  };
}

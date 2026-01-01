{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pygments,
  six,
  wcwidth,
  pytestCheckHook,
  pyte,
  ptyprocess,
  pexpect,
}:

buildPythonPackage rec {
  pname = "lineedit";
  version = "0.1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = "lineedit";
    rev = "v${version}";
    sha256 = "fq2NpjIQkIq1yzXEUxi6cz80kutVqcH6MqJXHtpTFsk=";
  };

  propagatedBuildInputs = [
    pygments
    six
    wcwidth
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyte
    pexpect
    ptyprocess
  ];

  pythonImportsCheck = [ "lineedit" ];

<<<<<<< HEAD
  meta = {
    description = "Readline library based on prompt_toolkit which supports multiple modes";
    homepage = "https://github.com/randy3k/lineedit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ savyajha ];
=======
  meta = with lib; {
    description = "Readline library based on prompt_toolkit which supports multiple modes";
    homepage = "https://github.com/randy3k/lineedit";
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

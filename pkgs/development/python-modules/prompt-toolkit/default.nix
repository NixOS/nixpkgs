{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "prompt-toolkit";
  version = "3.0.51";
  pyproject = true;

  src = fetchPypi {
    pname = "prompt_toolkit";
    inherit version;
    hash = "sha256-kxoWLjsn/JDIbxtIux+yxSjCdhR15XycBt4TMRx7VO0=";
  };

  postPatch = ''
    # https://github.com/prompt-toolkit/python-prompt-toolkit/issues/1988
    substituteInPlace src/prompt_toolkit/__init__.py \
      --replace-fail 'metadata.version("prompt_toolkit")' '"${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [ wcwidth ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # tests/test_completion.py:206: AssertionError
    # https://github.com/prompt-toolkit/python-prompt-toolkit/issues/1657
    "test_pathcompleter_can_expanduser"
  ];

  pythonImportsCheck = [ "prompt_toolkit" ];

  meta = with lib; {
    description = "Python library for building powerful interactive command lines";
    longDescription = ''
      prompt_toolkit could be a replacement for readline, but it can be
      much more than that. It is cross-platform, everything that you build
      with it should run fine on both Unix and Windows systems. Also ships
      with a nice interactive Python shell (called ptpython) built on top.
    '';
    homepage = "https://github.com/jonathanslenders/python-prompt-toolkit";
    changelog = "https://github.com/prompt-toolkit/python-prompt-toolkit/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}

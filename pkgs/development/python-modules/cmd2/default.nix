{ lib
, stdenv
, attrs
, buildPythonPackage
, colorama
, fetchPypi
, glibcLocales
, importlib-metadata
, pyperclip
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools-scm
, typing-extensions
, vim
, wcwidth
}:

buildPythonPackage rec {
  pname = "cmd2";
  version = "2.1.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25dbb2e9847aaa686a8a21e84e3d101db8b79f5cb992e044fc54210ab8c0ad41";
  };

  LC_ALL = "en_US.UTF-8";

  buildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    colorama
    pyperclip
    wcwidth
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    glibcLocales
    pytest-mock
    vim
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '' + lib.optionalString stdenv.isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    mkdir bin
    echo '#!${stdenv.shell}' > bin/pbpaste
    echo '#!${stdenv.shell}' > bin/pbcopy
    chmod +x bin/{pbcopy,pbpaste}
    export PATH=$(realpath bin):$PATH
  '';

  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [ "cmd2" ];

  meta = with lib; {
    description = "Enhancements for standard library's cmd module";
    homepage = "https://github.com/python-cmd2/cmd2";
    maintainers = with maintainers; [ teto ];
  };
}

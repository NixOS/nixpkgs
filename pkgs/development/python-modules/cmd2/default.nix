{ lib, stdenv, fetchPypi, buildPythonPackage, pythonOlder, isPy3k
, pyperclip, six, pyparsing, vim, wcwidth, colorama, attrs
, contextlib2 ? null, typing ? null, setuptools-scm
, pytest, mock ? null, pytest-mock
, which, glibcLocales
}:
buildPythonPackage rec {
  pname = "cmd2";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25dbb2e9847aaa686a8a21e84e3d101db8b79f5cb992e044fc54210ab8c0ad41";
  };

  LC_ALL="en_US.UTF-8";

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    mkdir bin
    echo '#!${stdenv.shell}' > bin/pbpaste
    echo '#!${stdenv.shell}' > bin/pbcopy
    chmod +x bin/{pbcopy,pbpaste}
    export PATH=$(realpath bin):$PATH
  '';

  disabled = !isPy3k;

  buildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    colorama
    pyperclip
    six
    pyparsing
    wcwidth
    attrs
  ]
  ++ lib.optionals (pythonOlder "3.5") [contextlib2 typing]
  ;


  doCheck = !stdenv.isDarwin;
  # pytest-cov
  # argcomplete  will generate errors
  checkInputs= [ pytest mock which vim glibcLocales pytest-mock ]
        ++ lib.optional (pythonOlder "3.6") [ mock ];
  checkPhase = ''
    # test_path_completion_user_expansion might be fixed in the next release
    py.test -k 'not test_path_completion_user_expansion'
  '';

  meta = with lib; {
    description = "Enhancements for standard library's cmd module";
    homepage = "https://github.com/python-cmd2/cmd2";
    maintainers = with maintainers; [ teto ];
  };
}

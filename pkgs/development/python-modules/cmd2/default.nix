{ stdenv, fetchPypi, buildPythonPackage, pythonOlder, isPy3k
, pyperclip, six, pyparsing, vim, wcwidth, colorama, attrs
, contextlib2 ? null, typing ? null, setuptools_scm
, pytest, mock ? null, pytest-mock
, which, glibcLocales
}:
buildPythonPackage rec {
  pname = "cmd2";
  version = "0.9.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba244b07c0b465ff54a6838dc61919599141dc92de1bf00bb0a70875189155e6";
  };

  LC_ALL="en_US.UTF-8";

  postPatch = stdenv.lib.optional stdenv.isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    mkdir bin
    echo '#${stdenv.shell}' > bin/pbpaste
    echo '#${stdenv.shell}' > bin/pbcopy
    chmod +x bin/{pbcopy,pbpaste}
    export PATH=$(realpath bin):$PATH
  '';

  disabled = !isPy3k;

  buildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    colorama
    pyperclip
    six
    pyparsing
    wcwidth
    attrs
  ]
  ++ stdenv.lib.optionals (pythonOlder "3.5") [contextlib2 typing]
  ;


  doCheck = !stdenv.isDarwin;
  # pytest-cov
  # argcomplete  will generate errors
  checkInputs= [ pytest mock which vim glibcLocales pytest-mock ]
        ++ stdenv.lib.optional (pythonOlder "3.6") [ mock ];
  checkPhase = ''
    # test_path_completion_user_expansion might be fixed in the next release
    py.test -k 'not test_path_completion_user_expansion'
  '';

  meta = with stdenv.lib; {
    description = "Enhancements for standard library's cmd module";
    homepage = https://github.com/python-cmd2/cmd2;
    maintainers = with maintainers; [ teto ];
  };
}

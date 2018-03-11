{ stdenv, fetchPypi, buildPythonPackage, pythonOlder
, pyperclip, six, pyparsing, vim
, contextlib2 ? null, subprocess32 ? null
, pytest, mock, which, fetchFromGitHub, glibcLocales
}:
buildPythonPackage rec {
  pname = "cmd2";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "python-cmd2";
    repo = "cmd2";
    rev = version;
    sha256 = "0nw2b7n7zg51bc3glxw0l9fn91mwjnjshklhmxhyvjbsg7khf64z";
  };

  LC_ALL="en_US.UTF-8";

  postPatch = stdenv.lib.optional stdenv.isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    mkdir bin
    echo '#/bin/sh' > bin/pbpaste
    echo '#/bin/sh' > bin/pbcopy
    chmod +x bin/{pbcopy,pbpaste}
    export PATH=$(realpath bin):$PATH
  '';

  checkInputs= [ pytest mock which vim glibcLocales ];
  checkPhase = ''
    # test_path_completion_user_expansion might be fixed in the next release
    py.test -k 'not test_path_completion_user_expansion'
  '';
  doCheck = !stdenv.isDarwin;

  propagatedBuildInputs = [
    pyperclip
    six
    pyparsing
  ]
  ++ stdenv.lib.optional (pythonOlder "3.5") contextlib2
  ++ stdenv.lib.optional (pythonOlder "3.0") subprocess32
  ;

  meta = with stdenv.lib; {
    description = "Enhancements for standard library's cmd module";
    homepage = https://github.com/python-cmd2/cmd2;
    maintainers = with maintainers; [ teto ];
  };
}

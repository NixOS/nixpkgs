{ stdenv, fetchPypi, buildPythonPackage, pythonOlder, isPy3k
, pyperclip, six, pyparsing, vim, wcwidth, colorama
, contextlib2 ? null
, pytest, mock, which, glibcLocales
}:
buildPythonPackage rec {
  pname = "cmd2";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wpw4f9zix30hfncm0hwxjjdx78zq26x3r8s9nvsq9vnxf41xb49";
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
  disabled = !isPy3k;

  propagatedBuildInputs = [
    colorama
    pyperclip
    six
    pyparsing
    wcwidth
  ]
  ++ stdenv.lib.optional (pythonOlder "3.5") contextlib2
  ;

  meta = with stdenv.lib; {
    description = "Enhancements for standard library's cmd module";
    homepage = https://github.com/python-cmd2/cmd2;
    maintainers = with maintainers; [ teto ];
  };
}

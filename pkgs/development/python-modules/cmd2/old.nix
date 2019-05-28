{ stdenv, buildPythonPackage, pythonOlder
, pyperclip, six, pyparsing, vim
, contextlib2 ? null, subprocess32 ? null
, pytest, mock, which, fetchFromGitHub, glibcLocales
, runtimeShell, wcwidth, enum34
}:
buildPythonPackage rec {
  pname = "cmd2";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "python-cmd2";
    repo = "cmd2";
    rev = version;
    sha256 = "1zil4z4qgvs8pxmz09g4352mxxir5j17k86r1qmwwv7fv93a80f9";
  };

  LC_ALL="en_US.UTF-8";

  postPatch = stdenv.lib.optional stdenv.isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    mkdir bin
    echo '#${runtimeShell}' > bin/pbpaste
    echo '#${runtimeShell}' > bin/pbcopy
    chmod +x bin/{pbcopy,pbpaste}
    export PATH=$(realpath bin):$PATH
  '';

  checkInputs= [ pytest mock which vim glibcLocales ];
  checkPhase = "py.test";
  doCheck = !stdenv.isDarwin;

  propagatedBuildInputs = [
    pyperclip
    six
    pyparsing
    wcwidth
    enum34
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

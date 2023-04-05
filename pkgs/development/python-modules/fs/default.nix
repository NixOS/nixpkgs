{ lib
, glibcLocales
, buildPythonPackage
, fetchPypi
, setuptools
, six
, appdirs
, scandir ? null
, backports_os ? null
, typing ? null
, pytz
, enum34
, pyftpdlib
, psutil
, mock
, pythonAtLeast
, isPy3k
, pytestCheckHook
, stdenv
}:

buildPythonPackage rec {
  pname = "fs";
  version = "2.4.16";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rpfH1RIT9LcLapWCklMCiQkN46fhWEHhCPvhRPBp0xM=";
  };

  buildInputs = [ glibcLocales ];

  # strong cycle with paramaterized
  doCheck = false;
  nativeCheckInputs = [ pyftpdlib mock psutil pytestCheckHook ];
  propagatedBuildInputs = [ six appdirs pytz setuptools ]
    ++ lib.optionals (!isPy3k) [ backports_os ]
    ++ lib.optionals (!pythonAtLeast "3.6") [ typing ]
    ++ lib.optionals (!pythonAtLeast "3.5") [ scandir ]
    ++ lib.optionals (!pythonAtLeast "3.5") [ enum34 ];

  LC_ALL="en_US.utf-8";

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [ "--ignore=tests/test_opener.py" ];

  disabledTests = [
    "user_data_repr"
  ] ++ lib.optionals (stdenv.isDarwin) [ # remove if https://github.com/PyFilesystem/pyfilesystem2/issues/430#issue-707878112 resolved
    "test_ftpfs"
  ] ++ lib.optionals (pythonAtLeast "3.9") [
    # update friend version of this commit: https://github.com/PyFilesystem/pyfilesystem2/commit/3e02968ce7da7099dd19167815c5628293e00040
    # merged into master, able to be removed after >2.4.1
    "test_copy_sendfile"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Filesystem abstraction";
    homepage    = "https://github.com/PyFilesystem/pyfilesystem2";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}

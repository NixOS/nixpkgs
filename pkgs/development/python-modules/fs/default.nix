{ lib
, glibcLocales
, buildPythonPackage
, fetchPypi
, six
, nose
, appdirs
, scandir
, backports_os
, typing
, pytz
, enum34
, pyftpdlib
, psutil
, mock
, pythonAtLeast
, isPy3k
, pytest
}:

buildPythonPackage rec {
  pname = "fs";
  version = "2.4.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc99d476b500f993df8ef697b96dc70928ca2946a455c396a566efe021126767";
  };

  buildInputs = [ glibcLocales ];
  checkInputs = [ nose pyftpdlib mock psutil pytest ];
  propagatedBuildInputs = [ six appdirs pytz ]
    ++ lib.optionals (!isPy3k) [ backports_os ]
    ++ lib.optionals (!pythonAtLeast "3.6") [ typing ]
    ++ lib.optionals (!pythonAtLeast "3.5") [ scandir ]
    ++ lib.optionals (!pythonAtLeast "3.5") [ enum34 ];

  LC_ALL="en_US.utf-8";

  checkPhase = ''
    HOME=$(mktemp -d) pytest -k 'not user_data_repr' --ignore=tests/test_opener.py
  '';

  meta = with lib; {
    description = "Filesystem abstraction";
    homepage    = "https://github.com/PyFilesystem/pyfilesystem2";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}

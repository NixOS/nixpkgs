{ lib, writeText, buildPythonPackage, isPy3k, fetchPypi
, openldap, cyrus_sasl, openssl }:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "2.4.39";
  name = "${pname}-${version}";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fb75108d27e8091de80dffa2ba3bf45c7a3bdc357e2959006aed52fa58bb2f3";
  };

  # Needed by tests to setup a mockup ldap server.
  preCheck = ''
    export BIN="${openldap}/bin"
    export SBIN="${openldap}/bin"
    export SLAPD="${openldap}/libexec/slapd"
    export SCHEMA="${openldap}/etc/schema"
  '';

  patches = lib.singleton (writeText "avoid-syslog.diff" ''
    diff a/Lib/slapdtest.py b/Lib/slapdtest.py
    --- a/Lib/slapdtest.py
    +++ b/Lib/slapdtest.py
    @@ -60,7 +60,8 @@ def combined_logger(
                 pass
         # for writing to syslog
         new_logger = logging.getLogger(log_name)
    -    if sys_log_format:
    +    # /dev/log does not exist in nix build environment.
    +    if False:
             my_syslog_formatter = logging.Formatter(
                 fmt=' '.join((log_name, sys_log_format)))
             my_syslog_handler = logging.handlers.SysLogHandler(
  '');

  NIX_CFLAGS_COMPILE = "-I${cyrus_sasl.dev}/include/sasl";
  propagatedBuildInputs = [openldap cyrus_sasl openssl];
}

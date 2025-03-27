{
  lib,
  stdenv,
  perl,
  fetchFromGitHub,
  autoreconfHook,
  nixosTests,
}:

let
  dataDir = "/var/lib/sympa";
  runtimeDir = "/run/sympa";
  perlEnv = perl.withPackages (
    p: with p; [
      ArchiveZip
      CGI
      CGIFast
      ClassSingleton
      DateTime
      DBI
      DateTimeFormatMail
      DateTimeTimeZone
      Encode
      FCGI
      FileCopyRecursive
      FileNFSLock
      FilePath
      HTMLParser
      HTMLFormatter
      HTMLTree
      HTMLStripScriptsParser
      IO
      IOStringy
      LWP
      libintl-perl

      MHonArc
      MIMECharset
      MIMETools
      MIMEEncWords
      MIMELiteHTML
      MailTools
      NetCIDR
      ScalarListUtils
      SysSyslog
      TermProgressBar
      TemplateToolkit
      URI
      UnicodeLineBreak
      UnicodeUTF8
      XMLLibXML

      ### Features
      Clone
      CryptEksblowfish

      DBDPg
      DBDSQLite
      DBDmysql

      DataPassword
      EncodeLocale
      IOSocketSSL
      MailDKIM
      NetDNS
      perlldap
      libnet
      SOAPLite
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "sympa";
  version = "6.2.76";

  src = fetchFromGitHub {
    owner = "sympa-community";
    repo = "sympa";
    rev = version;
    sha256 = "sha256-XvLTO2Wau34zMoi+5d16JnWd/K96w2py9xC5oLlRfRM=";
  };

  configureFlags = [
    "--enable-fhs"
    "--without-initdir"
    "--without-unitsdir"
    "--without-smrshdir"

    "--with-lockdir=${runtimeDir}"
    "--with-piddir=${runtimeDir}"
    "--with-confdir=${dataDir}/etc"
    "--sysconfdir=${dataDir}/etc"
    "--with-spooldir=${dataDir}/spool"
    "--with-expldir=${dataDir}/list_data"
  ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perlEnv ];
  patches = [ ./make-docs.patch ];

  prePatch = ''
    patchShebangs po/sympa/add-lang.pl
  '';

  preInstall = ''
    mkdir "$TMP/bin"
    for i in chown chgrp chmod; do
      echo '#!${stdenv.shell}' >> "$TMP/bin/$i"
      chmod +x "$TMP/bin/$i"
    done
    PATH="$TMP/bin:$PATH"
  '';

  postInstall = ''
    rm -rf "$TMP/bin"
  '';

  passthru.tests = {
    inherit (nixosTests) sympa;
  };

  meta = with lib; {
    description = "Open source mailing list manager";
    homepage = "https://www.sympa.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      sorki
    ];
    platforms = platforms.all;
  };
}

{
  buildPecl,
  lib,
  libssh2,
}:

buildPecl rec {
  version = "1.3.1";
  pname = "ssh2";

  sha256 = "sha256-kJOh+NJNxlg2AnsOI5xQ3o1err+DlrwzMf3TjF1pr9k=";

  buildInputs = [ libssh2 ];
  configureFlags = [ "--with-ssh2=${libssh2.dev}" ];

  meta = with lib; {
    changelog = "https://pecl.php.net/package-info.php?package=ssh2&version=${version}";
    description = "PHP bindings for the libssh2 library";
    license = licenses.php301;
    homepage = "https://github.com/php/pecl-networking-ssh2";
    maintainers = teams.php.members ++ [ maintainers.ostrolucky ];
  };
}

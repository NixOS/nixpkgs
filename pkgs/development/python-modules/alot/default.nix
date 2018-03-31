{ stdenv, lib, buildPythonPackage, fetchFromGitHub, isPy3k
, notmuch, urwid, urwidtrees, twisted, python_magic, configobj, mock, file, gpgme
, service-identity
, gnupg ? null, sphinx, awk ? null, procps ? null, future ? null
, withManpage ? false }:


buildPythonPackage rec {
  pname = "alot";
  version = "0.7";
  outputs = [ "out" ] ++ lib.optional withManpage "man";

  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "alot";
    rev = "${version}";
    sha256 = "1y932smng7qx7ybmqw4qh75b0lv9imfs5ak9fd0qhysij8kpmdhi";
  };

  postPatch = ''
    substituteInPlace alot/defaults/alot.rc.spec \
      --replace "themes_dir = string(default=None)" \
                "themes_dir = string(default='$out/share/themes')"
  '';

  nativeBuildInputs = lib.optional withManpage sphinx;

  propagatedBuildInputs = [
    notmuch
    urwid
    urwidtrees
    twisted
    python_magic
    configobj
    service-identity
    file
    gpgme
  ];

  # some twisted tests need the network (test_env_set... )
  doCheck = false;
  postBuild = lib.optionalString withManpage "make -C docs man";

  checkInputs =  [ awk future mock gnupg procps ];

  postInstall = lib.optionalString withManpage ''
    mkdir -p $out/man
    cp -r docs/build/man $out/man
  ''
  + ''
    mkdir -p $out/share/applications
    cp -r extra/themes $out/share

    sed "s,/usr/bin,$out/bin,g" extra/alot.desktop > $out/share/applications/alot.desktop
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pazz/alot;
    description = "Terminal MUA using notmuch mail";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ garbas ];
  };
}

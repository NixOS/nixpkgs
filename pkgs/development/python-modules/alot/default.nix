{ stdenv, isPy3k, buildPythonPackage, fetchFromGitHub, notmuch, urwid, urwidtrees, twisted, python_magic, configobj, pygpgme, mock, file, gpgme }:

buildPythonPackage rec {
  rev = "0.5.1";
  name = "alot-${rev}";

  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "alot";
    inherit rev;
    sha256 = "0ipkhc5wllfq78lg47aiq4qih0yjq8ad9xkrbgc88xk8pk9166i8";
  };

  postPatch = ''
    substituteInPlace alot/defaults/alot.rc.spec \
      --replace "themes_dir = string(default=None)" \
                "themes_dir = string(default='$out/share/themes')"
  '';

  propagatedBuildInputs =
    [ notmuch
      urwid
      urwidtrees
      twisted
      python_magic
      configobj
      pygpgme
      mock
    ];

  postInstall = ''
    mkdir -p $out/share
    cp -r extra/themes $out/share
    wrapProgram $out/bin/alot \
      --prefix LD_LIBRARY_PATH : '${stdenv.lib.makeLibraryPath [ notmuch file gpgme ]}'
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pazz/alot;
    description = "Terminal MUA using notmuch mail";
    platforms = platforms.linux;
    maintainers = with maintainers; [ garbas profpatsch ];
  };
}

{ stdenv, lib, buildPythonPackage, python, fetchFromGitHub, fetchpatch, isPy3k
, notmuch, urwid, urwidtrees, twisted, python_magic, configobj, mock, file, gpgme
, service-identity
, gnupg ? null, sphinx, awk ? null, procps ? null, future ? null
, withManpage ? false }:


buildPythonPackage rec {
  pname = "alot";
  version = "0.9.1";
  outputs = [ "out" ] ++ lib.optional withManpage "man";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "alot";
    rev = version;
    sha256 = "0s94m17yph1gq9f2svipb3bbwbw1s4j3zf2xkg5h91006v8286r6";
  };

  postPatch = ''
    substituteInPlace alot/settings/manager.py --replace /usr/share "$out/share"
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

  postInstall = let
    completionPython = python.withPackages (ps: [ ps.configobj ]);
  in lib.optionalString withManpage ''
    mkdir -p $out/man
    cp -r docs/build/man $out/man
  ''
  + ''
    mkdir -p $out/share/{applications,alot}
    cp -r extra/themes $out/share/alot

    substituteInPlace extra/completion/alot-completion.zsh \
      --replace "python3" "${completionPython.interpreter}"
    install -D extra/completion/alot-completion.zsh $out/share/zsh/site-functions/_alot

    sed "s,/usr/bin,$out/bin,g" extra/alot.desktop > $out/share/applications/alot.desktop
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/pazz/alot";
    description = "Terminal MUA using notmuch mail";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edibopp ];
  };
}

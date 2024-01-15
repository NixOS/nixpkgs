{ lib, stdenv, fetchzip, xorg }:

stdenv.mkDerivation {
  pname = "profont";
  version = "2019-11";

  # Note: stripRoot doesn't work because the archive
  # contains the metadata directory `__MACOSX`.
  src = fetchzip {
    url = "https://tobiasjung.name/downloadfile.php?file=profont-x11.zip";
    sha256 = "12dbm87wvcpmn7nzgzwlk45cybp091diara8blqm6129ps27z6kb";
    stripRoot = false;
  } + /profont-x11;

  srcOtb = fetchzip {
    url = "https://tobiasjung.name/downloadfile.php?file=profont-otb.zip";
    sha256 = "18rfhfqrsj3510by0w1a7ak5as6r2cxh8xv02xc1y30mfa6g24x6";
    stripRoot = false;
  } + /profont-otb;

  dontBuild = true;

  nativeBuildInputs = [ xorg.mkfontscale ];

  installPhase = ''
    mkdir -p "$out/share/fonts/misc"
    for f in *.pcf; do
      gzip -n -9 -c "$f" > "$out/share/fonts/misc/$f.gz"
    done
    install -D -m 644 LICENSE -t "$out/share/doc/$pname"
    install -D -m 644 "$srcOtb/profontn.otb" -t $out/share/fonts/misc
    mkfontdir "$out/share/fonts/misc"
  '';

  meta = with lib; {
    homepage = "https://tobiasjung.name/profont/";
    description = "A monospaced font created to be a most readable font for programming";
    maintainers = with maintainers; [ myrl ];
    license = licenses.mit;
    platforms = platforms.all;
  };

}

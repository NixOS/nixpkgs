{stdenv, fetchzip}:

let
  version = "3.3";
in fetchzip {
  name = "jost-${version}";
  url = "https://github.com/indestructible-type/Jost/releases/download/${version}/Jost.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256="00nrhs3aif2hc4yhjhbn9ywmydl2w0g0hv5m5is8gv7wx8yi2j9z";

  meta = with stdenv.lib; {
    homepage = https://github.com/indestructible-type/Jost;
    description = "A sans serif font by Indestructible Type";
    license = licenses.ofl;
    maintainers = [ maintainers.ar1a ];
  };
}

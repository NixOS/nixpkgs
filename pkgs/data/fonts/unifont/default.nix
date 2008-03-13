args: with args; with debPackage;
debBuild ({
  src = fetchurl {
    url = mirror://debian/pool/main/u/unifont/unifont_1.0.orig.tar.gz;
    sha256 = "0bg8d6c7w51n5409g0n7vqk3aagbzb5aird5r02vw0yz7w6i729l";
  };
  patch = fetchurl {
    url = mirror://debian/pool/main/u/unifont/unifont_1.0-4.diff.gz;
    sha256 = "08j0rrf7hc05izchmsx9f9hg7vnyqdvbmba4b9jl8wfhvd1b09fd";
  };
  name = "unifont-1.0-4";
  buildInputs = [mkfontscale mkfontdir bdftopcf fontutil perl];
  meta = {
    description = "Unicode font for Base Multilingual Plane.";
  };
  extraReplacements = ''sed -e s@/usr/bin/perl@${perl}/bin/perl@ -i hex2bdf.unsplit'';
  omitConfigure = true;
  Install = ''
    ensureDir $out/share/fonts
    cp unifont.pcf $out/share/fonts
    cd $out/share/fonts
    mkfontdir 
    mkfontscale
  '';
  extraInstallDeps = ["defEnsureDir"];
} // args)

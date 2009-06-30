a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.1.9" a; 
  buildInputs = with a; [
    pkgconfig pygtk
  ];
  propagatedBuildInputs = with a; [
    libsexy python gtk glib pango libxml2
  ];
in
rec {
  src = fetchurl {
    url = "http://releases.chipx86.com/libsexy/sexy-python/sexy-python-${version}.tar.gz";
    sha256 = "05bgcsxwkp63rlr8wg6znd46cfbhrzc5wh70jabsi654pxxjb39d";
  };

  inherit buildInputs propagatedBuildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall" "postInstall"];
  postInstall = a.fullDepEntry (''
    ln -s $out/lib/python*/site-packages/gtk-2.0/* $out/lib/python*/site-packages/
  '') ["minInit"];

  name = "python-libsexy-" + version;
  meta = {
    description = "Python libsexy bindings";
  };
}

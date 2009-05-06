args: with args;

stdenv.mkDerivation {
  inherit version;
  name = "openexr-${version}";
  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/openexr/openexr-${version}.tar.gz";
    sha256 = if (version == "1.6.1") then "0l2rdbx9lg4qk2ms98hwbsnzpggdrx3pbjl6pcvrrpjqp5m905n6"
             else if (version == "1.4.0") then "1y3dxakpg9651dgbj2xp6r4044b5gi74g23w3sr5cs6xi7cywv7m"
               else abort "not supported version";
  };
  buildInputs = [pkgconfig zlib] ++ (lib.optional (args ? ctl) (args.ctl));
  propagatedBuildInputs = [pkgconfig zlib ilmbase];
  configureFlags = "--enable-imfexamples";
  patches = [ ./stringh.patch ];
}

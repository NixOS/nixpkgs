{stdenv, version}:

{
  inherit version;

  platform = if stdenv.system == "i686-linux"
    then "linux-i386"
    else if stdenv.system == "x86_64-linux"
    then "linux-x86_64"
    else if stdenv.system == "i686-darwin"
    then "macos-i386"
    else if stdenv.system == "x86_64-darwin"
    then "macos-x86_64"
    else abort "no snapshot to boostrap for this platform (missing platform url suffix)";

  target = if stdenv.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else if stdenv.system == "i686-darwin"
    then "i686-apple-darwin"
    else if stdenv.system == "x86_64-darwin"
    then "x86_64-apple-darwin"
    else abort "no snapshot to boostrap for this platform (missing target triple";

  meta = with stdenv.lib; {
    homepage = http://www.rust-lang.org/;
    description = "A safe, concurrent, practical language";
    maintainers = with maintainers; [ madjar cstrahan ];
    license = map (builtins.getAttr "shortName") [ licenses.mit licenses.asl20 ];
    platforms = platforms.linux;
  };

  name = "rustc-${version}";
}

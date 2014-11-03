{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "sbcl-bootstrap-${version}";
  version = "1.1.8";

  src = if stdenv.isDarwin
    then fetchurl {
      url = mirror://sourceforge/project/sbcl/sbcl/1.1.8/sbcl-1.1.8-x86-64-darwin-binary.tar.bz2;
      sha256 = "006pr88053wclvbjfjdypnbiw8wymbzdzi7a6kbkpdfn4zf5943j";
    }
    else fetchurl {
      url = mirror://sourceforge/project/sbcl/sbcl/1.1.8/sbcl-1.1.8-x86-64-linux-binary.tar.bz2;
      sha256 = "0lh1jglxlfwk4cm6sgwk1jnb6ikhbrkx7p5aha2nbmkd6zl96prx";
    };

  installPhase = ''
    mkdir -p $out/bin
    cp -p src/runtime/sbcl $out/bin
    mkdir -p $out/share/sbcl
    cp -p output/sbcl.core $out/share/sbcl
  '';

  meta = {
    description = "Lisp compiler";
    homepage = "http://www.sbcl.org";
    license = "bsd";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}

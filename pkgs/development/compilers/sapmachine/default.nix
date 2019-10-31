{ stdenv, fetchurl, unzip }:

let
  version = "13.0.1";
  #version = "11.0.5";

  sha256_linux = "21b2a4d3d80bb8434235e9416d347967ca4714e1c54e49136e739b8447c87e56";
  sha256_darwin = "f0111c1cba6d1b1042724df7d28f2a274981bd90fbfe6c940ca5cc9ceddd8825";
#  sha256_linux = "f8b849bbd044acfd38972987305bd4c8bf5706a794ec12b51f1ed747a492ca55";
#  sha256_darwin = "31fcd79060ca5c62be9866450cf501361c0e478f3418c366a136f63a7a530059";

  platform = if stdenv.isDarwin then "osx" else "linux";
  sha256 = if stdenv.isDarwin then sha256_darwin else sha256_linux;
  homepath = if stdenv.isDarwin then "Contents/Home" else ".";

jdk = stdenv.mkDerivation rec {
  inherit version platform sha256 homepath;

  name = "sapmachine";

  src = fetchurl {
    url = "https://github.com/SAP/SapMachine/releases/download/sapmachine-${version}/sapmachine-jdk-${version}_${platform}-x64_bin.tar.gz";
    sha256 = sha256;
  };

  buildInputs = [ unzip];
  
  installPhase = ''
    mkdir -p $out
    cp -r ./$homepath/* "$out/"

    # Set JAVA_HOME
    mkdir -p $out/nix-support
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
    EOF
  '';

  passthru = {
    home = jdk;
  };

  meta = with stdenv.lib; {
    homepage = https://sap.github.io/SapMachine/;
    license = licenses.gpl2;
    description = "SAP supported version of OpenJDK";
    longDescription = ''
      This project contains a downstream version of 
      the OpenJDK project. It is used to build and 
      maintain a SAP supported version of OpenJDK 
      for SAP customers and partners who wish to 
      use OpenJDK to run their applications.
    '';
    maintainers = with maintainers; [ choas ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
};
in jdk

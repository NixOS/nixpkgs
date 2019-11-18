{ stdenv, fetchurl, unzip }:

let
  version = "11.0.5";

  sha256_linux = "f8b849bbd044acfd38972987305bd4c8bf5706a794ec12b51f1ed747a492ca55";
  sha256_darwin = "31fcd79060ca5c62be9866450cf501361c0e478f3418c366a136f63a7a530059";

  platform = if stdenv.isDarwin then "osx" else "linux";
  sha256 = if stdenv.isDarwin then sha256_darwin else sha256_linux;
  homepath = if stdenv.isDarwin then "Contents/Home" else ".";

in stdenv.mkDerivation rec {
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
}

args: with args;
stdenv.mkDerivation rec {
  name = "adobe_flex_sdk_4.0.0.14159_mpl";

  src = fetchurl {
    # This is the open source distribution
    url = http://fpdownload.adobe.com/pub/flex/sdk/builds/flex4/flex_sdk_4.0.0.14159_mpl.zip;
    sha256 = "1x12sji6g42bm1h7jndkda5vpah6vnkpc13qwq0c4xvbsh8757v5";
  };

  phases="installPhase";

  buildInputs = [ unzip ];

  # Why do shell scripts have \r\n ??
  # moving to /opt because jdk has lib/xercesImpl.jar as well
  installPhase = ''
    unzip ${src}
    t=$out/opt/flex-sdk
    ensureDir $t $out/bin
    mv * $t
    rm $t/bin/*.exe $t/bin/*.bat
    sed 's/$//' -i $t/bin/*
    for i in $t/bin/*; do
      b="$(basename "$i")";
    cat > "$out/bin/$b" << EOF
    #!/bin/sh
    exec $t/bin/$b "\$@"
    EOF
      chmod +x $out/bin/$b $t/bin/$b
    done
  '';

  meta = { 
      description = "flex sdk flash / action script developement kit";
      homepage = "http://www.adobe.com/support/documentation/en/flex/3/releasenotes_flex3_sdk.html#installation";
      license = "MPLv1.1"; #  Mozilla Public License Version 1.1
  };
}

args: with args;
stdenv.mkDerivation rec {
  name = "adobe_flex_sdk_3.4.1.10084_mpl";

  src = fetchurl {
    # This is the open source distribution
    url = http://fpdownload.adobe.com/pub/flex/sdk/builds/flex3/flex_sdk_3.4.1.10084_mpl.zip;
    sha256 = "0bq0cnq25qyr3g64sqqc20y3mmnhgh07p3ylxd2iq0ha8cdis7z0";
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

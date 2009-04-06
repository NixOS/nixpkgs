args: with args;
stdenv.mkDerivation rec {
  name = "adobe-flex-sdk-3.3.0.4852_mpl";

  src = fetchurl {
    url = http://flexorg.wip3.adobe.com/flexsdk/3.3.0.4852/flex_sdk_3.3.0.4852_mpl.zip;
    sha256 = "1gsm774afc7zwv3hyib5n6fpdbnd0dh6z7r2amjf38fm96jw7a99";
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
    sed 's/$//' -i $t/bin/mxmlc
    rm $t/bin/*.exe
    for i in $t/bin/mxmlc; do
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

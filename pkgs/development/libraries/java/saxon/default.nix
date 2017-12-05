{ stdenv, fetchurl, unzip, jre }:

let
  common = { pname, version, src, description
           , prog ? null, jar ? null, license ? stdenv.lib.licenses.mpl20 }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";
      inherit pname version src;

      nativeBuildInputs = [ unzip ];

      buildCommand = let
        prog' = if prog == null then pname else prog;
        jar' = if jar == null then pname else jar;
      in ''
        unzip $src -d $out
        mkdir -p $out/bin $out/share $out/share/java
        cp -s "$out"/*.jar "$out/share/java/"  # */
        rm -rf $out/notices
        mv $out/doc $out/share
        cat > $out/bin/${prog'} <<EOF
        #! $shell
        export JAVA_HOME=${jre}
        exec ${jre}/bin/java -jar $out/${jar'}.jar "\$@"
        EOF
        chmod a+x $out/bin/${prog'}
      '';

      meta = with stdenv.lib; {
        inherit description license;
        homepage = http://saxon.sourceforge.net/;
        maintainers = with maintainers; [ rvl ];
        platforms = platforms.all;
      };
    };

in {
  saxon = common {
    pname = "saxon";
    version = "6.5.3";
    src = fetchurl {
      url = mirror://sourceforge/saxon/saxon6_5_3.zip;
      sha256 = "0l5y3y2z4wqgh80f26dwwxwncs8v3nkz3nidv14z024lmk730vs3";
    };
    description = "XSLT 1.0 processor";
    # http://saxon.sourceforge.net/saxon6.5.3/conditions.html
    license = stdenv.lib.licenses.mpl10;
  };

  saxonb = common {
    pname = "saxonb";
    version = "8.8";
    jar = "saxon8";
    src = fetchurl {
      url = mirror://sourceforge/saxon/saxonb8-8j.zip;
      sha256 = "15bzrfyd2f1045rsp9dp4znyhmizh1pm97q8ji2bc0b43q23xsb8";
    };
    description = "Complete and conformant processor of XSLT 2.0, XQuery 1.0, and XPath 2.0";
  };
}

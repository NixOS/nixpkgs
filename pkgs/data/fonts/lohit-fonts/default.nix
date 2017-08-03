{ stdenv, fetchurl, lib }:
let
  fonts = {
    assamese = { label = "Assamese"; version = "2.91.3" ; sha256 = "0kbdvi8f7vbvsain9zmnj9h43a6bmdkhk5c2wzg15100w7wf6lpq"; };
    bengali = { label = "Bengali"; version = "2.91.3" ; sha256 = "1wdd2dkqaflf6nm5yc7llkfxin6g0zb2sbcd5g2xbrl0gwwcmkij"; };
    devanagari = { label = "Devanagari script"; version = "2.95.2" ; sha256 = "1ss0j0pcfrg1vsypnm0042y4bn7b84mi6lbfsvr6rs89lb5swvn2"; };
    gujarati = { label = "Gujarati"; version = "2.92.2-and-4.2.2" ; sha256 = "1i27yjhn3x31a89x1hjs6rskdwp2kh0hibq1xiz3rgqil2m0jar6"; };
    gurmukhi = { label = "Gurmukhi script"; version = "2.91.0" ; sha256 = "0z8a30mnyhlfvqhnggfk0369hqg779ihqyhcmpxj0sf9dmb1i0mj"; }; # renamed from Punjabi
    kannada = { label = "Kannada"; version = "2.5.3" ; sha256 = "1x9fb5z1bwmfi0y1fdnzizzjxhbxp272wxznx36063kjf25bb9pi"; };
    malayalam = { label = "Malayalam"; version = "2.92.0" ; sha256 = "1syv1irxh5xl0z0d5kwankhlmi7s2dg4wpp58nq0mkd3rhm5q8qw"; };
    marathi = { label = "Marathi"; version = "2.94.0" ; sha256 = "0y9sca6gbfbafv52v0n2r1xfs8rg6zmqs4vp9sjfc1c6yqhzagl4"; };
    nepali = { label = "Nepali"; version = "2.94.0" ; sha256 = "0c56141rpxc30581i3gisg8kfaadxhqjhgshni6g7a7rn6l4dx17"; };
    odia = { label = "Odia"; version = "2.91.0" ; sha256 = "15iz9kdf9k5m8wcn2iqlqjm758ac3hvnk93va6kac06frxnhw9lp"; }; # renamed from Oriya
    tamil-classical = { label = "Classical Tamil"; version = "2.5.3" ; sha256 = "0ci4gk8qhhysjza69nncgmqmal8s4n8829icamvlzbmjdd4s2pij"; };
    tamil = { label = "Tamil"; version = "2.91.1" ; sha256 = "1ir6kjl48apwk41xbpj0x458k108s7i61yzpkfhqcy1fkcr7cngj"; };
    telugu = { label = "Telugu"; version = "2.5.4" ; sha256 = "06gdba7690y20l7nsi8fnnimim5hlq7hik0mpk2fzw4w39hjybk9"; };
  };
  gplfonts = {
    # GPL fonts removed from later releases
    kashmiri = { label = "Kashmiri"; version = "2.4.3" ; sha256 = "0ax8xzv4pz17jnsjdklawncsm2qn7176wbxykswygpzdd5lr0gg9"; };
    konkani = { label = "Konkani"; version = "2.4.3" ; sha256 = "03zc27z26a60aaggrqx4d6l0jgggciq8p83v6vgg0k6l3apvcp45"; };
    maithili = { label = "Maithili"; version = "2.4.3" ; sha256 = "0aqwnhq1namvvb77f2vssahixqf4xay7ja4q8qc312wxkajdqh4a"; };
    sindhi = { label = "Sindhi"; version = "2.4.3" ; sha256 = "00imfbn01yc2g5zdyydks9w3ndkawr66l9qk2idlvw3yz3sw2kf1"; };
  };
  mkpkg = license: name: {label, version, sha256}:
    stdenv.mkDerivation {
      name = "lohit-${name}-${version}";

      src = fetchurl {
        url = "https://fedorahosted.org/releases/l/o/lohit/lohit-${name}-ttf-${version}.tar.gz";
        inherit sha256;
      };

      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp -v *.ttf $out/share/fonts/truetype/

        mkdir -p $out/etc/fonts/conf.d
        cp -v *.conf $out/etc/fonts/conf.d

        mkdir -p "$out/share/doc/lohit-${name}"
        cp -v ChangeLog* COPYRIGHT* "$out/share/doc/lohit-${name}/"
      '';

      meta = {
        inherit license;
        description = "Free and open source fonts for Indian languages (" + label + ")";
        homepage = https://fedorahosted.org/lohit/;
        maintainers = [ lib.maintainers.mathnerd314 lib.maintainers.ttuegel ];
        # Set a non-zero priority to allow easy overriding of the
        # fontconfig configuration files.
        priority = 5;
        platforms = stdenv.lib.platforms.unix;
      };
    };

in
# Technically, GPLv2 with usage exceptions
lib.mapAttrs (mkpkg lib.licenses.gpl2) gplfonts //
lib.mapAttrs (mkpkg lib.licenses.ofl) fonts

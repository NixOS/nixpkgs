{ fetchzip, lib }:
let
  fonts = {
    assamese        = { label = "Assamese";          version = "2.91.5"; sha256 = "06cw416kgw0m6883n5ixmpniinsd747rdmacf06z83w1hqwj2js6"; };
    bengali         = { label = "Bengali";           version = "2.91.5"; sha256 = "1j7gfmkzzyk9mivy09a9yfqxpidw52hw48dyh4qkci304mspcbvr"; };
    devanagari      = { label = "Devanagari script"; version = "2.95.4"; sha256 = "1c17xirzx5rf7xpmkrm94jf9xrzckyagwnqn3pyag28lyj8x67m5"; };
    gujarati        = { label = "Gujarati";          version = "2.92.4"; sha256 = "0xdgmkikz532zxj239wr73l24qnzxhra88f52146x7fsb7gpvfb1"; };
    gurmukhi        = { label = "Gurmukhi script";   version = "2.91.2"; sha256 = "1xk1qvc0xwcmjcavj9zmy4bbphffdlv7sldmqlk30ch5fy5r0ypb"; }; # renamed from Punjabi
    kannada         = { label = "Kannada";           version = "2.5.4" ; sha256 = "0sax56xg98p2nf0nsvba42hhz946cs7q0gidiz9zfpb6pbgwxdgg"; };
    malayalam       = { label = "Malayalam";         version = "2.92.2"; sha256 = "18sca59fj9zvqhagbix35i4ld2n4mwv57q04pijl5gvpyfb1abs8"; };
    marathi         = { label = "Marathi";           version = "2.94.2"; sha256 = "0cjjxxlhqmdmhr35s4ak0ma89456daik5rqrn6pdzj39098lmci7"; };
    nepali          = { label = "Nepali";            version = "2.94.2"; sha256 = "1p7lif136xakfqkbv6p1lb56rs391b25vn4bxrjdfvsk0r0h0ry3"; };
    odia            = { label = "Odia";              version = "2.91.2"; sha256 = "0z5rc4f9vfrfm8h2flzf5yx44x50jqdmmzifkmjwczib3hpg2ila"; }; # renamed from Oriya
    tamil-classical = { label = "Classical Tamil";   version = "2.5.4" ; sha256 = "0svmj3dhk0195mhdwjhi3qgwa83223irb32fp12782sj9njdvyi2"; };
    tamil           = { label = "Tamil";             version = "2.91.3"; sha256 = "0qyw9p8alyvjryyw8a25q3gfyrhby49mjb0ydgggf5ckd07kblcm"; };
    telugu          = { label = "Telugu";            version = "2.5.5" ; sha256 = "07p41686ypmclj9d3njp01lvrgssqxa4s5hsbrqfjrnwd3rjspzr"; };
  };
  gplfonts = {
    # GPL fonts removed from later releases
    kashmiri        = { label = "Kashmiri";          version = "2.4.3" ; sha256 = "0c6whklad9bscymrlcbxj4fdvh4cdf40vb61ykbp6mapg6dqxwhn"; };
    konkani         = { label = "Konkani";           version = "2.4.3" ; sha256 = "0pcb5089dabac1k6ymqnbnlyk7svy2wnb5glvhsd8glycjhrcp70"; };
    maithili        = { label = "Maithili";          version = "2.4.3" ; sha256 = "1yfwv7pcj7k4jryz0s6mb56bq7fs15g56y7pi5yd89q1f8idk6bc"; };
    sindhi          = { label = "Sindhi";            version = "2.4.3" ; sha256 = "1iywzyy185bvfsfi5pp11c8bzrp40kni2cpwcmxqwha7c9v8brlc"; };
  };

  mkpkg = license: name: {label, version, sha256}: fetchzip {
    name = "lohit-${name}-${version}";

    url = "https://releases.pagure.org/lohit/lohit-${name}-ttf-${version}.tar.gz";

    postFetch = ''
      tar -xzf $downloadedFile --strip-components=1

      mkdir -p $out/share/fonts/truetype
      cp -v *.ttf $out/share/fonts/truetype/

      mkdir -p $out/etc/fonts/conf.d
      cp -v *.conf $out/etc/fonts/conf.d

      mkdir -p "$out/share/doc/lohit-${name}"
      cp -v ChangeLog* COPYRIGHT* "$out/share/doc/lohit-${name}/"
    '';

    inherit sha256;

    meta = {
      inherit license;
      description = "Free and open source fonts for Indian languages (" + label + ")";
      homepage = https://pagure.io/lohit;
      maintainers = [ lib.maintainers.mathnerd314 lib.maintainers.ttuegel ];
      # Set a non-zero priority to allow easy overriding of the
      # fontconfig configuration files.
      priority = 5;
    };
  };

in
# Technically, GPLv2 with usage exceptions
lib.mapAttrs (mkpkg lib.licenses.gpl2) gplfonts //
lib.mapAttrs (mkpkg lib.licenses.ofl) fonts

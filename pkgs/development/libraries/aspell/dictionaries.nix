{lib, stdenv, fetchurl, aspell, which, writeScript}:

/* HOWTO:

   * Add some of these to your profile or systemPackages.

     ~~~~
     environment.systemPackages = [
       aspell
       aspellDicts.en
       aspellDicts.en-computers
       aspellDicts.en-science
     ];
     ~~~~

   * Rebuild and switch to the new profile.
   * Add something like

     ~~~~
     master en_US
     extra-dicts en-computers.rws
     add-extra-dicts en_US-science.rws
     ~~~~

     to `/etc/aspell.conf` or `~/.aspell.conf`.
   * Check that `aspell -a` starts without errors.
   * (optional) Check your config with `aspell dump config | grep -vE '^(#|$)'`.
   * Enjoy.

*/

let

  /* Function to compile an Aspell dictionary.  Fortunately, they all
     build in the exact same way. */
  buildDict =
    {shortName, fullName, ...}@args:

    stdenv.mkDerivation ({
      pname = "aspell-dict-${shortName}";

      strictDeps = true;

      nativeBuildInputs = [ aspell which ];

      dontAddPrefix = true;

      configurePlatforms = [ ];

      preBuild = "makeFlagsArray=(dictdir=$out/lib/aspell datadir=$out/lib/aspell)";

      meta = {
        description = "Aspell dictionary for ${fullName}";
        platforms = lib.platforms.all;
      } // (args.meta or {});
    } // removeAttrs args [ "meta" ]);


  buildOfficialDict =
    {language, version, filename, fullName, sha256, ...}@args:
    let buildArgs = {
      shortName = "${language}";

      src = fetchurl {
        url = "mirror://gnu/aspell/dict/${language}/${filename}-${language}-${version}.tar.bz2";
        inherit sha256;
      };

      /* Remove any instances of u-deva.cmap and u-deva.cset since
         they are included in the main aspell package and can
         cause conflicts otherwise. */
      postInstall = ''
        rm -f $out/lib/aspell/u-deva.{cmap,cset}
      '';

      passthru.updateScript = writeScript "update-aspellDict-${language}" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p nix curl gnused common-updater-scripts
        set -eu -o pipefail

        # List tarballs in the dictionary's subdirectory via HTTPS and
        # the simple list method of Apache's mod_autoindex.
        #
        # Catalan dictionary has an exception where an earlier version
        # compares as newer because the versioning scheme has changed.
        versions=$(
            echo '[';
            curl -s 'https://ftp.gnu.org/gnu/aspell/dict/${language}/?F=0' | \
                sed -r 's/.* href="${filename}-${language}-([A-Za-z0-9_+.-]+)\.tar\.bz2".*/"\1"/;t;d' | \
                if [ '${language}' = "ca" ]; then grep -v 20040130-1; else cat; fi; \
            echo ']')

        # Sort versions in descending order using Nix's and take the first as the latest.
        sortVersions="(with builtins; head (sort (a: b: compareVersions a b > 0) $versions))"
        # nix-instantiate outputs Nix strings (with quotes), so remove them to get
        # a result similar to `nix eval --raw`.
        latestVersion=$(nix-instantiate --eval --expr "$sortVersions" | tr -d '"')

        update-source-version aspellDicts.${language} "$latestVersion"
      '';

      meta = {
        homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
      } // (args.meta or {});

    } // lib.optionalAttrs (lib.elem language [ "is" "nb" ]) {
      # These have Windows-1251 encoded non-ASCII characters,
      # so need some special handling.
      unpackPhase = ''
        runHook preUnpack

        tar -xf $src --strip-components=1 || true

        runHook postUnpack
      '';

      postPatch = lib.getAttr language {
        is = ''
          cp icelandic.alias íslenska.alias
          sed -i 's/ .slenska\.alias/ íslenska.alias/g' Makefile.pre
        '';
        nb = ''
          cp bokmal.alias bokmål.alias
          sed -i 's/ bokm.l\.alias/ bokmål.alias/g' Makefile.pre
        '';
      };
    } // removeAttrs args [ "language" "filename" "sha256" "meta" ];
    in buildDict buildArgs;

  /* Function to compile txt dict files into Aspell dictionaries. */
  buildTxtDict =
    {langInputs ? [], ...}@args:
    buildDict ({
      propagatedUserEnvPackages = langInputs;

      preBuild = ''
        # Aspell can't handle multiple data-dirs
        # Copy everything we might possibly need
        ${lib.concatMapStringsSep "\n" (p: ''
          cp -a ${p}/lib/aspell/* .
        '') ([ aspell ] ++ langInputs)}
        export ASPELL_CONF="data-dir $(pwd)"

        aspell-create() {
          target=$1
          shift
          echo building $target
          aspell create "$@" master ./$target.rws
        }

        words-only() {
          awk -F'\t' '{print $1}' | sort | uniq
        }

        # drop comments
        aspell-affix() {
          words-only \
            | grep -a -v '#' \
            | aspell-create "$@"
        }

        # Hack: drop comments and words with affixes
        aspell-plain() {
          words-only \
            | grep -a -v '#' \
            | grep -a -v '/' \
            | aspell-create "$@"
        }

        aspell-install() {
          install -d $out/lib/aspell
          for a in "$@"; do
            echo installing $a
            install -t $out/lib/aspell $a.rws
          done
        }
      '';

      dontUnpack = true;
    } // args);

in rec {

  ### Languages

  af = buildOfficialDict {
    language = "af";
    version = "0.50-0";
    fullName = "Afrikaans";
    filename = "aspell";
    sha256 = "00p6k2ndi0gzfr5fkbvx4hkcpj223pidjvmxg0r384arrap00q4x";
    meta.license = lib.licenses.lgpl21Only;
  };

  am = buildOfficialDict {
    language = "am";
    version = "0.03-1";
    fullName = "Amharic";
    filename = "aspell6";
    sha256 = "11ylp7gjq94wfacyawvp391lsq26rl1b84f268rjn7l7z0hxs9xz";
    meta.license = lib.licenses.publicDomain;
  };

  ar = buildOfficialDict {
    language = "ar";
    version = "1.2-0";
    fullName = "Arabic";
    filename = "aspell6";
    sha256 = "1avw40bp8yi5bnkq64ihm2rldgw34lk89yz281q9bmndh95a47h4";
    meta.license = lib.licenses.gpl2Only;
  };

  ast = buildOfficialDict {
    language = "ast";
    version = "0.01";
    fullName = "Asturian";
    filename = "aspell6";
    sha256 = "14hg85mxcyvdigf96yvslk7f3v9ngdsxn85qpgwkg31k3k83xwj3";
    meta.license = lib.licenses.gpl2Only;
  };

  az = buildOfficialDict {
    language = "az";
    version = "0.02-0";
    fullName = "Azerbaijani";
    filename = "aspell6";
    sha256 = "1hs4h1jscpxf9f9iyk6mvjqsnhkf0yslkbjhjkasqqcx8pn7cc86";
    meta.license = lib.licenses.gpl2Only;
  };

  be = buildOfficialDict {
    language = "be";
    version = "0.01";
    fullName = "Belarusian";
    filename = "aspell5";
    sha256 = "1svls9p7rsfi3hs0afh0cssj006qb4v1ik2yzqgj8hm10c6as2sm";
    meta.license = lib.licenses.gpl2Only;
  };

  bg = buildOfficialDict {
    language = "bg";
    version = "4.1-0";
    fullName = "Bulgarian";
    filename = "aspell6";
    sha256 = "1alacmgpfk0yrgq83y23d16fhav1bxmb98kg8d2a5r9bvh2h0mvl";
    meta.license = lib.licenses.gpl2Only;
  };

  bn = buildOfficialDict {
    language = "bn";
    version = "0.01.1-1";
    fullName = "Bengali";
    filename = "aspell6";
    sha256 = "1nc02jd67iggirwxnhdvlvaqm0xfyks35c4psszzj3dhzv29qgxh";
    meta.license = lib.licenses.gpl2Only;
  };

  br = buildOfficialDict {
    language = "br";
    version = "0.50-2";
    fullName = "Breton";
    filename = "aspell";
    sha256 = "0fradnm8424bkq9a9zhpl2132dk7y95xmw45sy1c0lx6rinjl4n2";
    meta.license = lib.licenses.gpl2Only;
  };

  ca = buildOfficialDict {
    language = "ca";
    version = "2.1.5-1";
    fullName = "Catalan";
    filename = "aspell6";
    sha256 = "1fb5y5kgvk25nlsfvc8cai978hg66x3pbp9py56pldc7vxzf9npb";
    meta.license = lib.licenses.gpl2Only;
  };

  cs = buildOfficialDict {
    language = "cs";
    version = "20040614-1";
    fullName = "Czech";
    filename = "aspell6";
    sha256 = "0rihj4hsw96pd9casvmpvw3r8040pfa28p1h73x4vyn20zwr3h01";
    meta.license = lib.licenses.gpl2Only;
  };

  csb = buildOfficialDict {
    language = "csb";
    version = "0.02-0";
    fullName = "Kashubian";
    filename = "aspell6";
    sha256 = "1612ypkm684wjvc7n081i87mlrrzif9simc7kyn177hfsl3ssrn1";
    meta.license = lib.licenses.gpl2Only;
  };

  cy = buildOfficialDict {
    language = "cy";
    version = "0.50-3";
    fullName = "Welsh";
    filename = "aspell";
    sha256 = "15vq601lzz1gi311xym4bv9lv1k21xcfn50jmzamw7h6f36rsffm";
    meta.license = lib.licenses.gpl2Only;
  };

  da = buildOfficialDict {
    language = "da";
    version = "1.4.42-1";
    fullName = "Danish";
    filename = "aspell5";
    sha256 = "1hfkmiyhgrx5lgrb2mffjbdn1hivrm73wcg7x0iid74p2yb0fjpp";
    meta.license = lib.licenses.gpl2Only;
  };

  de = buildOfficialDict {
    language = "de";
    version = "20161207-7-0";
    fullName = "German";
    filename = "aspell6";
    sha256 = "0wamclvp66xfmv5wff96v6gdlnfv4y8lx3f8wvxyzm5imwgms4n2";
    meta.license = lib.licenses.gpl2Plus;
  };

  de-alt = buildOfficialDict {
    language = "de-alt";
    version = "2.1-1";
    fullName = "German - Old Spelling";
    filename = "aspell6";
    sha256 = "0wwc2l29svv3fv041fh6vfa5m3hi9q9pkbxibzq1ysrsfin3rl9n";
    meta.license = lib.licenses.gpl2Only;
  };

  el = buildOfficialDict {
    language = "el";
    version = "0.08-0";
    fullName = "Greek";
    filename = "aspell6";
    sha256 = "1ljcc30zg2v2h3w5h5jr5im41mw8jbsgvvhdd2cii2yzi8d0zxja";
    meta.license = lib.licenses.gpl2Only;
  };

  en = buildOfficialDict {
    language = "en";
    version = "2020.12.07-0";
    fullName = "English";
    filename = "aspell6";
    sha256 = "1cwzqkm8gr1w51rpckwlvb43sb0b5nbwy7s8ns5vi250515773sc";
    # some parts are under a custom free license others are just stated to be"public domain"
    # see the Copyright file in the source for further information
    meta.license = with lib.licenses; [
      free
      publicDomain
      bsdOriginalUC
    ];
  };

  eo = buildOfficialDict {
    language = "eo";
    version = "2.1.20000225a-2";
    fullName = "Esperanto";
    filename = "aspell6";
    sha256 = "09vf0mbiicbmyb4bwb7v7lgpabnylg0wy7m3hlhl5rjdda6x3lj1";
    meta.license = lib.licenses.gpl2Only;
  };

  es = buildOfficialDict {
    language = "es";
    version = "1.11-2";
    fullName = "Spanish";
    filename = "aspell6";
    sha256 = "1k5g328ac1hdpp6fsg57d8md6i0aqcwlszp3gbmp5706wyhpydmd";
    meta.license = lib.licenses.gpl2Only;
  };

  et = buildOfficialDict {
    language = "et";
    version = "0.1.21-1";
    fullName = "Estonian";
    filename = "aspell6";
    sha256 = "0jdjfa2fskirhnb70fy86xryp9r6gkl729ib8qcjmsma7nm5gs5i";
    meta.license = lib.licenses.lgpl21Only;
  };

  fa = buildOfficialDict {
    language = "fa";
    version = "0.11-0";
    fullName = "Persian";
    filename = "aspell6";
    sha256 = "0nz1ybwv56q7nl9ip12hfmdch1vyyq2j55bkjcns13lshzm2cba8";
    meta.license = lib.licenses.gpl2Only;
  };

  fi = buildOfficialDict {
    language = "fi";
    version = "0.7-0";
    fullName = "Finnish";
    filename = "aspell6";
    sha256 = "07d5s08ba4dd89cmwy9icc01i6fjdykxlb9ravmhdrhi8mxz1mzq";
    meta.license = lib.licenses.gpl2Only;
  };

  fo = buildOfficialDict {
    language = "fo";
    version = "0.2.16-1";
    fullName = "Faroese";
    filename = "aspell5";
    sha256 = "022yz5lll20xrzizcyb7wksm3fgwklnvgnir5la5qkxv770dvq7p";
    meta.license = lib.licenses.gpl2Only;
  };

  fr = buildOfficialDict {
    language = "fr";
    version = "0.50-3";
    fullName = "French";
    filename = "aspell";
    sha256 = "14ffy9mn5jqqpp437kannc3559bfdrpk7r36ljkzjalxa53i0hpr";
    meta.license = lib.licenses.gpl2Only;
  };

  fy = buildOfficialDict {
    language = "fy";
    version = "0.12-0";
    fullName = "Frisian";
    filename = "aspell6";
    sha256 = "1almi6n4ni91d0rzrk8ig0473m9ypbwqmg56hchz76j51slwyirl";
    meta.license = lib.licenses.gpl2Only;
  };

  ga = buildOfficialDict {
    language = "ga";
    version = "4.5-0";
    fullName = "Irish";
    filename = "aspell5";
    sha256 = "0y869mmvfb3bzadfgajwa2rfb0xfhi6m9ydwgxkb9v2claydnps5";
    meta.license = lib.licenses.gpl2Only;
  };

  gd = buildOfficialDict {
    language = "gd";
    version = "0.1.1-1";
    fullName = "Scottish Gaelic";
    filename = "aspell5";
    sha256 = "0a89irv5d65j5m9sb0k36851x5rs0wij12gb2m6hv2nsfn5a05p3";
    meta.license = lib.licenses.gpl2Only;
  };

  gl = buildOfficialDict {
    language = "gl";
    version = "0.5a-2";
    fullName = "Galician";
    filename = "aspell6";
    sha256 = "12pwghmy18fcdvf9hvhb4q6shi339hb1kwxpkz0bhw0yjxjwzkdk";
    meta.license = lib.licenses.gpl2Only;
  };

  grc = buildOfficialDict {
    language = "grc";
    version = "0.02-0";
    fullName = "Ancient Greek";
    filename = "aspell6";
    sha256 = "1zxr8958v37v260fkqd4pg37ns5h5kyqm54hn1hg70wq5cz8h512";
    meta.license = lib.licenses.gpl3Only;
  };

  gu = buildOfficialDict {
    language = "gu";
    version = "0.03-0";
    fullName = "Gujarati";
    filename = "aspell6";
    sha256 = "04c38jnl74lpj2jhjz4zpqbs2623vwc71m6wc5h4b1karid14b23";
    meta.license = lib.licenses.gpl2Only;
  };

  gv = buildOfficialDict {
    language = "gv";
    version = "0.50-0";
    fullName = "Manx Gaelic";
    filename = "aspell";
    sha256 = "1rknf4yaw9s29c77sdzg98nhnmjwpicdb69igmz1n768npz2drmv";
    meta.license = lib.licenses.gpl2Only;
  };

  he = buildOfficialDict {
    language = "he";
    version = "1.0-0";
    fullName = "Hebrew";
    filename = "aspell6";
    sha256 = "13bhbghx5b8g0119g3wxd4n8mlf707y41vlf59irxjj0kynankfn";
    meta.license = lib.licenses.gpl2Only;
  };

  hi = buildOfficialDict {
    language = "hi";
    version = "0.02-0";
    fullName = "Hindi";
    filename = "aspell6";
    sha256 = "0drs374qz4419zx1lf2k281ydxf2750jk5ailafj1x0ncz27h1ys";
    meta.license = lib.licenses.gpl2Only;
  };

  hil = buildOfficialDict {
    language = "hil";
    version = "0.11-0";
    fullName = "Hiligaynon";
    filename = "aspell5";
    sha256 = "1s482fsfhzic9qa80al4418q3ni3gfn2bkwkd2y46ydrs17kf2jp";
    meta.license = lib.licenses.gpl2Only;
  };

  hr = buildOfficialDict {
    language = "hr";
    version = "0.51-0";
    fullName = "Croatian";
    filename = "aspell";
    sha256 = "09aafyf1vqhaxvcf3jfzf365k394b5pf0iivsr2ix5npah1h7i1a";
    meta.license = lib.licenses.lgpl21Only;
  };

  hsb = buildOfficialDict {
    language = "hsb";
    version = "0.02-0";
    fullName = "Upper Sorbian";
    filename = "aspell6";
    sha256 = "0bi2vhz7n1vmg43wbbh935pmzihv80iyz9z65j94lxf753j2m7wd";
    meta.license = lib.licenses.gpl2Only;
  };

  hu = buildOfficialDict {
    language = "hu";
    version = "0.99.4.2-0";
    fullName = "Hungarian";
    filename = "aspell6";
    sha256 = "1d9nybip2k1dz69zly3iv0npbi3yxgfznh1py364nxzrbjsafd9k";
    meta.license = lib.licenses.gpl2Only;
  };

  hus = buildOfficialDict {
    language = "hus";
    version = "0.03-1";
    fullName = "Huastec";
    filename = "aspell6";
    sha256 = "09glipfpkz9xch17z11zw1yn2z7jx1f2svfmjn9l6wm1s5qz6a3d";
    meta.license = lib.licenses.gpl3Only;
  };

  hy = buildOfficialDict {
    language = "hy";
    version = "0.10.0-0";
    fullName = "Armenian";
    filename = "aspell6";
    sha256 = "1w5wq8lfl2xp1nid30b1j5qmya4vjyidq0vpr4y3gf53jc08vsid";
    meta.license = lib.licenses.gpl2Only;
  };

  ia = buildOfficialDict {
    language = "ia";
    version = "0.50-1";
    fullName = "Interlingua";
    filename = "aspell";
    sha256 = "0bqcpgsa72pga24fv4fkw38b4qqdvqsw97jvzvw7q03dc1cwp5sp";
    meta.license = lib.licenses.lgpl21Only;
  };

  id = buildOfficialDict {
    language = "id";
    version = "1.2-0";
    fullName = "Indonesian";
    filename = "aspell5";
    sha256 = "023knfg0q03f7y5w6xnwa1kspnrcvcnky8xvdms93n2850414faj";
    meta.license = lib.licenses.gpl2Only;
  };

  is = buildOfficialDict {
    language = "is";
    version = "0.51.1-0";
    fullName = "Icelandic";
    filename = "aspell";
    sha256 = "1mp3248lhbr13cj7iq9zs7h5ix0dcwlprp5cwrkcwafrv8lvsd9h";
    meta.license = lib.licenses.gpl2Only;
  };

  it = buildOfficialDict {
    language = "it";
    version = "2.2_20050523-0";
    fullName = "Italian";
    filename = "aspell6";
    sha256 = "1gdf7bc1a0kmxsmphdqq8pl01h667mjsj6hihy6kqy14k5qdq69v";
    meta.license = lib.licenses.gpl2Plus;
  };

  kn = buildOfficialDict {
    language = "kn";
    version = "0.01-1";
    fullName = "Kannada";
    filename = "aspell6";
    sha256 = "10sk0wx4x4ds1403kf9dqxv9yjvh06w8qqf4agx57y0jlws0n0fb";
    meta.license = lib.licenses.gpl3Only;
  };

  ku = buildOfficialDict {
    language = "ku";
    version = "0.20-1";
    fullName = "Kurdi";
    filename = "aspell5";
    sha256 = "09va98krfbgdaxl101nmd85j3ysqgg88qgfcl42c07crii0pd3wn";
    meta.license = lib.licenses.gpl2Only;
  };

  ky = buildOfficialDict {
    language = "ky";
    version = "0.01-0";
    fullName = "Kirghiz";
    filename = "aspell6";
    sha256 = "0kzv2syjnnn6pnwx0d578n46hg2l0j62977al47y6wabnhjjy3z1";
    meta.license = lib.licenses.gpl2Only;
  };

  la = buildOfficialDict {
    language = "la";
    version = "20020503-0";
    fullName = "Latin";
    filename = "aspell6";
    sha256 = "1199inwi16dznzl087v4skn66fl7h555hi2palx6s1f3s54b11nl";
    meta.license = lib.licenses.gpl2Only;
  };

  lt = buildOfficialDict {
    language = "lt";
    version = "1.2.1-0";
    fullName = "Lithuanian";
    filename = "aspell6";
    sha256 = "1asjck911l96q26zj36lmz0jp4b6pivvrf3h38zgc8lc85p3pxgn";
    meta.license = lib.licenses.bsd3;
  };

  lv = buildOfficialDict {
    language = "lv";
    version = "0.5.5-1";
    fullName = "Latvian";
    filename = "aspell6";
    sha256 = "12pvs584a6437ijndggdqpp5s7d0w607cimpkxsjwasnx83f4c1w";
    meta.license = lib.licenses.gpl2Only;
  };

  mg = buildOfficialDict {
    language = "mg";
    version = "0.03-0";
    fullName = "Malagasy";
    filename = "aspell5";
    sha256 = "0hdhbk9b5immjp8l5h4cy82gwgsqzcqbb0qsf7syw333w4rgi0ji";
    meta.license = lib.licenses.gpl2Only;
  };

  mi = buildOfficialDict {
    language = "mi";
    version = "0.50-0";
    fullName = "Maori";
    filename = "aspell";
    sha256 = "12bxplpd348yx8d2q8qvahi9dlp7qf28qmanzhziwc7np8rixvmy";
    meta.license = lib.licenses.lgpl21Only;
  };

  mk = buildOfficialDict {
    language = "mk";
    version = "0.50-0";
    fullName = "Macedonian";
    filename = "aspell";
    sha256 = "0wcr9n882xi5b7a7ln1hnhq4vfqd5gpqqp87v01j0gb7zf027z0m";
    meta.license = lib.licenses.gpl2Only;
  };

  ml = buildOfficialDict {
    language = "ml";
    version = "0.03-1";
    fullName = "Malayalam";
    filename = "aspell6";
    sha256 = "1zcn4114gwia085fkz77qk13z29xrbp53q2qvgj2cvcbalg5bkg4";
    meta.license = lib.licenses.gpl3Only;
  };

  mn = buildOfficialDict {
    language = "mn";
    version = "0.06-2";
    fullName = "Mongolian";
    filename = "aspell6";
    sha256 = "150j9y5c9pw80fwp5rzl5q31q9vjbxixaqljkfwxjb5q93fnw6rg";
    meta.license = lib.licenses.gpl2Only;
  };

  mr = buildOfficialDict {
    language = "mr";
    version = "0.10-0";
    fullName = "Marathi";
    filename = "aspell6";
    sha256 = "0cvgb2l40sppqbi842ivpznsh2xzp1d4hxc371dll8z0pr05m8yk";
    meta.license = lib.licenses.gpl2Only;
  };

  ms = buildOfficialDict {
    language = "ms";
    version = "0.50-0";
    fullName = "Malay";
    filename = "aspell";
    sha256 = "0vr4vhipcfhsxqfs8dim2ph7iiixn22gmlmlb375bx5hgd9y7i1w";
    meta.license = lib.licenses.fdl12Only;
  };

  mt = buildOfficialDict {
    language = "mt";
    version = "0.50-0";
    fullName = "Maltese";
    filename = "aspell";
    sha256 = "1d2rl1nlfjq6rfywblvx8m88cyy2x0mzc0mshzbgw359c2nwl3z0";
    meta.license = lib.licenses.lgpl21Only;
  };

  nb = buildOfficialDict {
    language = "nb";
    version = "0.50.1-0";
    fullName = "Norwegian Bokmal";
    filename = "aspell";
    sha256 = "12i2bmgdnlkzfinb20j2a0j4a20q91a9j8qpq5vgabbvc65nwx77";
    meta.license = lib.licenses.gpl2Only;
  };

  nds = buildOfficialDict {
    language = "nds";
    version = "0.01-0";
    fullName = "Low Saxon";
    filename = "aspell6";
    sha256 = "1nkjhwzn45dizi89d19q4bqyd87cim8xyrgr655fampgkn31wf6f";
    meta.license = lib.licenses.lgpl21Only;
  };

  nl = buildOfficialDict {
    language = "nl";
    version = "0.50-2";
    fullName = "Dutch";
    filename = "aspell";
    sha256 = "0ffb87yjsh211hllpc4b9khqqrblial4pzi1h9r3v465z1yhn3j4";
    # Emacs expects a language called "nederlands".
    postInstall = ''
      echo "add nl.rws" > $out/lib/aspell/nederlands.multi
    '';
    # from the Copyright file:
    # > The nl-aspell package includes the GPL COPYRIGHT file but no explicit copyright
    # > notice. Since he was using autoconf this could have been added automatically.
    # wtf whatever
    meta.license = lib.licenses.free;
  };

  nn = buildOfficialDict {
    language = "nn";
    version = "0.50.1-1";
    fullName = "Norwegian Nynorsk";
    filename = "aspell";
    sha256 = "0w2k5l5rbqpliripgqwiqixz5ghnjf7i9ggbrc4ly4vy1ia10rmc";
    meta.license = lib.licenses.gpl2Only;
  };

  ny = buildOfficialDict {
    language = "ny";
    version = "0.01-0";
    fullName = "Chichewa";
    filename = "aspell5";
    sha256 = "0gjb92vcg60sfgvrm2f6i89sfkgb179ahvwlgs649fx3dc7rfvqp";
    meta.license = lib.licenses.gpl2Only;
  };

  or = buildOfficialDict {
    language = "or";
    version = "0.03-1";
    fullName = "Oriya";
    filename = "aspell6";
    sha256 = "0kzj9q225z0ccrlbkijsrafy005pbjy14qcnxb6p93ciz1ls7zyn";
    meta.license = lib.licenses.gpl2Only;
  };

  pa = buildOfficialDict {
    language = "pa";
    version = "0.01-1";
    fullName = "Punjabi";
    filename = "aspell6";
    sha256 = "0if93zk10pyrs38wwj3vpcdm01h51m5z9gm85h3jxrpgqnqspwy7";
    meta.license = lib.licenses.gpl2Only;
  };

  pl = buildOfficialDict {
    language = "pl";
    version = "6.0_20061121-0";
    fullName = "Polish";
    filename = "aspell6";
    sha256 = "0kap4kh6bqbb22ypja1m5z3krc06vv4n0hakiiqmv20anzy42xq1";
    meta.license = with lib.licenses; [
      gpl2Only
      lgpl21Only
      mpl11
      cc-sa-10
    ];
  };

  pt_BR = buildOfficialDict {
    language = "pt_BR";
    version = "20131030-12-0";
    fullName = "Brazilian Portuguese";
    filename = "aspell6";
    sha256 = "1xqlpk21s93c6blkdnpk7l62q9fxjvzdv2x86chl8p2x1gdrj3gb";
    meta.license = with lib.licenses; [
      lgpl21Only
      lgpl21Plus
      gpl3Plus
    ];
  };

  pt_PT = buildOfficialDict {
    language = "pt_PT";
    version = "20190329-1-0";
    fullName = "Portuguese";
    filename = "aspell6";
    sha256 = "0ld0d0ily4jqifjfsxfv4shbicz6ymm2gk56fq9gbzra1j4qnw75";
    meta.license = with lib.licenses; [
      lgpl21Plus
      gpl3Plus
      mpl11
    ];
  };

  qu = buildOfficialDict {
    language = "qu";
    version = "0.02-0";
    fullName = "Quechua";
    filename = "aspell6";
    sha256 = "009z0zsvzq7r3z3m30clyibs94v77b92h5lmzmzxlns2p0lpd5w0";
    meta.license = lib.licenses.gpl2Only;
  };

  ro = buildOfficialDict {
    language = "ro";
    version = "3.3-2";
    fullName = "Romanian";
    filename = "aspell5";
    sha256 = "0gb8j9iy1acdl11jq76idgc2lbc1rq3w04favn8cyh55d1v8phsk";
    meta.license = lib.licenses.gpl2Only;
  };

  ru = buildOfficialDict {
    language = "ru";
    version = "0.99f7-1";
    fullName = "Russian";
    filename = "aspell6";
    sha256 = "0ip6nq43hcr7vvzbv4lwwmlwgfa60hrhsldh9xy3zg2prv6bcaaw";
    meta.license = lib.licenses.free;
  };

  rw = buildOfficialDict {
    language = "rw";
    version = "0.50-0";
    fullName = "Kinyarwanda";
    filename = "aspell";
    sha256 = "10gh8g747jbrvfk2fn3pjxy1nhcfdpwgmnvkmrp4nd1k1qp101il";
    meta.license = lib.licenses.gpl2Only;
  };

  sc = buildOfficialDict {
    language = "sc";
    version = "1.0";
    fullName = "Sardinian";
    filename = "aspell5";
    sha256 = "0hl7prh5rccsyljwrv3m1hjcsphyrrywk2qvnj122irbf4py46jr";
    meta.license = lib.licenses.gpl2Only;
  };

  sk = buildOfficialDict {
    language = "sk";
    version = "2.01-2";
    fullName = "Slovak";
    filename = "aspell6";
    sha256 = "19k0m1v5pcf7xr4lxgjkzqkdlks8nyb13bvi1n7521f3i4lhma66";
    meta.license = with lib.licenses; [
      lgpl21Only
      gpl2Only
      mpl11
    ];
  };

  sl = buildOfficialDict {
    language = "sl";
    version = "0.50-0";
    fullName = "Slovenian";
    filename = "aspell";
    sha256 = "1l9kc5g35flq8kw9jhn2n0bjb4sipjs4qkqzgggs438kywkx2rp5";
    meta.license = lib.licenses.gpl2Only;
  };

  sr = buildOfficialDict {
    language = "sr";
    version = "0.02";
    fullName = "Serbian";
    filename = "aspell6";
    sha256 = "12cj01p4nj80cpf7m3s4jsaf0rsfng7s295j9jfchcq677xmhpkh";
    meta.license = lib.licenses.lgpl21Only;
  };

  sv = buildOfficialDict {
    language = "sv";
    version = "0.51-0";
    fullName = "Swedish";
    filename = "aspell";
    sha256 = "02jwkjhr32kvyibnyzgx3smbnm576jwdzg3avdf6zxwckhy5fw4v";
    meta.license = lib.licenses.lgpl21Only;
  };

  sw = buildOfficialDict {
    language = "sw";
    version = "0.50-0";
    fullName = "Swahili";
    filename = "aspell";
    sha256 = "15zjh7hdj2b4dgm5bc12w1ims9q357p1q3gjalspnyn5gl81zmby";
    meta.license = lib.licenses.lgpl21Only;
  };

  ta = buildOfficialDict {
    language = "ta";
    version = "20040424-1";
    fullName = "Tamil";
    filename = "aspell6";
    sha256 = "0sj8ygjsyvnr93cs6324y7az7k2vyw7rjxdc9vnm7z60lbqm5xaj";
    meta.license = lib.licenses.gpl2Only;
  };

  te = buildOfficialDict {
    language = "te";
    version = "0.01-2";
    fullName = "Telugu";
    filename = "aspell6";
    sha256 = "0pgcgxz7dz34zxp9sb85jjzbg3ky6il5wmhffz6ayrbsfn5670in";
    meta.license = lib.licenses.gpl2Only;
  };

  tet = buildOfficialDict {
    language = "tet";
    version = "0.1.1";
    fullName = "Tetum";
    filename = "aspell5";
    sha256 = "17n0y4fhjak47j9qnqf4m4z6zra6dn72rwhp7ig0hhlgqk4ldmcx";
    meta.license = lib.licenses.gpl2Only;
  };

  tk = buildOfficialDict {
    language = "tk";
    version = "0.01-0";
    fullName = "Turkmen";
    filename = "aspell5";
    sha256 = "02vad4jqhr0xpzqi5q5z7z0xxqccbn8j0c5dhpnm86mnr84l5wl6";
    meta.license = lib.licenses.gpl2Only;
  };

  tl = buildOfficialDict {
    language = "tl";
    version = "0.02-1";
    fullName = "Tagalog";
    filename = "aspell5";
    sha256 = "1kca6k7qnpfvvwjnq5r1n242payqsjy96skmw78m7ww6d0n5vdj8";
    meta.license = lib.licenses.gpl2Only;
  };

  tn = buildOfficialDict {
    language = "tn";
    version = "1.0.1-0";
    fullName = "Setswana";
    filename = "aspell5";
    sha256 = "0q5x7c6z88cn0kkpk7q1craq34g4g03v8x3xcj5a5jia3l7c5821";
    meta.license = lib.licenses.gpl2Only;
  };

  tr = buildOfficialDict {
    language = "tr";
    version = "0.50-0";
    fullName = "Turkish";
    filename = "aspell";
    sha256 = "0jpvpm96ga7s7rmsm6rbyrrr22b2dicxv2hy7ysv5y7bbq757ihb";
    meta.license = lib.licenses.gpl2Only;
  };

  uk = buildOfficialDict {
    language = "uk";
    version = "1.4.0-0";
    fullName = "Ukrainian";
    filename = "aspell6";
    sha256 = "137i4njvnslab6l4s291s11xijr5jsy75lbdph32f9y183lagy9m";
    meta.license = with lib.licenses; [
      lgpl2Plus
      gpl2Plus
    ];
  };

  uz = buildOfficialDict {
    language = "uz";
    version = "0.6-0";
    fullName = "Uzbek";
    filename = "aspell6";
    sha256 = "0sg3wlyply1idpq5ypyj7kgnaadaiskci1sqs811yhg2gzyc3092";
    meta.license = lib.licenses.gpl2Only;
  };

  vi = buildOfficialDict {
    language = "vi";
    version = "0.01.1-1";
    fullName = "Vietnamese";
    filename = "aspell6";
    sha256 = "05vwgvf1cj45azhflywx69javqdvqd1f20swrc2d3c32pd9mvn1w";
    meta.license = lib.licenses.gpl2Only;
  };

  wa = buildOfficialDict {
    language = "wa";
    version = "0.50-0";
    fullName = "Walloon";
    filename = "aspell";
    sha256 = "1r1zwz7xkx40dga9vf5wc9ja3jwk1dkpcr1kaa7wryvslf5al5ss";
    meta.license = lib.licenses.gpl2Only;
  };

  yi = buildOfficialDict {
    language = "yi";
    version = "0.01.1-1";
    fullName = "Yiddish";
    filename = "aspell6";
    sha256 = "0mi842l4038bx3ll2wx9nz44nqrg1x46h5b02zigi1hbbddd6ycq";
    meta.license = lib.licenses.gpl2Only;
  };

  zu = buildOfficialDict {
    language = "zu";
    version = "0.50-0";
    fullName = "Zulu";
    filename = "aspell";
    sha256 = "15k7gaxrnqnssdyk9l6g27dq317dqp9jz5yzafd25ri01g6mb8iz";
    meta.license = lib.licenses.lgpl21Only;
  };

  ### Jargons

  en-computers = buildTxtDict {
    shortName = "en-computers";
    fullName = "English Computer Jargon";
    version = "0";

    src = fetchurl {
      url = "https://mrsatterly.com/computer.dic";
      sha256 = "1vzk7cdvcm9r1c6mgxpabrdcpvghdv9mjmnf6iq5wllcif5nsw2b";
    };

    langInputs = [ en ];

    buildPhase = ''
      runHook preBuild
      cat $src | aspell-affix en-computers --dont-validate-words --lang=en
      runHook postBuild
    '';
    installPhase = "aspell-install en-computers";

    meta = {
      homepage = "https://mrsatterly.com/spelling.html";
      license = lib.licenses.wtfpl; # as a comment the source file
    };
  };

  en-science = buildTxtDict {
    shortName = "en-science";
    fullName = "English Scientific Jargon";
    version = "0-unstable-2015-07-27";

    src1 = fetchurl {
      url = "https://web.archive.org/web/20180806094650if_/http://jpetrie.net/wp-content/uploads/custom_scientific_US.txt";
      hash = "sha256-I5d/jf/5v9Nptu2H9qfvMBzSwJYoQOTEzJfQTxKoWN8=";
    };

    src2 = fetchurl {
      url = "https://web.archive.org/web/20180131231829if_/http://jpetrie.net/wp-content/uploads/custom_scientific_UK.txt";
      hash = "sha256-oT4nUiev5q4QjHeuF8jNVBcyyHE9fdH9+uDMkZsOWp8=";
    };

    langInputs = [ en ];

    buildPhase = ''
      runHook preBuild
      cat $src1 | aspell-plain en_US-science --dont-validate-words --lang=en
      cat $src2 | aspell-plain en_GB-science --dont-validate-words --lang=en
      runHook postBuild
    '';
    installPhase = "aspell-install en_US-science en_GB-science";

    meta = {
      homepage = "https://web.archive.org/web/20210425104207/http://www.jpetrie.net/scientific-word-list-for-spell-checkersspelling-dictionaries/";
      # no license is given so we have to assume it is unfree
      license = lib.licenses.unfree;
    };

  };

}

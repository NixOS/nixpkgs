{ fetchMaven }:

rec {
  aether_0_9_0_M2 = fetchMaven {
    version = "0.9.0.M2";
    baseName = "aether";
    package = "/org/eclipse/aether";
    sha512 = "0ampl2jkkc1f5cbigmi1b5nnxhb9qqzz0nyfb5a2vzbw3ri7ry8dj6xgjznlpxib46zxgaxcsvhxq2yx6a9i8chnzvgghccwpl808yi";
    type = "pom";
  };

  animalSnifferParent_1_11 = fetchMaven {
    version = "1.11";
    baseName = "animal-sniffer-parent";
    package = "/org/codehaus/mojo";
    sha512 = "3w9l3b4qxzmlwmaqppn1d794ycqf5piilv44fc74jccbgahdsq1as8dvyknnj2610yklwxx3146s7f0c3ms8y93alv02wybjwk5fd07";
    type = "pom";
  };

  apache_3 = fetchMaven {
    version = "3";
    baseName = "apache";
    package = "/org/apache";
    sha512 = "3vvqxycj7zxa9dfxa6f8i2azdvxc7ci68fk3nlkjvhsglmwr39wf6cwgj6qqlrw3mabzs714lgz0wdacsidncadxzfw774ck20dq1rf";
    type = "pom";
  };

  apache_4 = fetchMaven {
    version = "4";
    baseName = "apache";
    package = "/org/apache";
    sha512 = "3yb998i1azfxdjk2ndcc19gzx12i0bdi6jqwp5mhwp9ac5dfsplkb5np4bkpsb948y8kpvw1pyvkx8rw0a0rvkxqzxr98ng5nq80vw6";
    type = "pom";
  };

  apache_5 = fetchMaven {
    version = "5";
    baseName = "apache";
    package = "/org/apache";
    sha512 = "3yb998i1azfxdjk2ndcc19gzx12i0bdi6jqwp5mhwp9ac5dfsplkb5np4bkpsb948y8kpvw1pyvkx8rw0a0rvkxqzxr98ng5nq80vw6";
    type = "pom";
  };

  apache_6 = fetchMaven {
    version = "6";
    baseName = "apache";
    package = "/org/apache";
    sha512 = "2nvwk7fhiqcbr4vrwl0d3g4wz25vll24ga9kyc89fzq6b9nr6bqfphrm5a73kdih97l5cqlszw8xc847viw2ss1mwabn590f01ykhj0";
    type = "pom";
  };

  apache_9 = fetchMaven {
    version = "9";
    baseName = "apache";
    package = "/org/apache";
    sha512 = "3yb998i1azfxdjk2ndcc19gzx12i0bdi6jqwp5mhwp9ac5dfsplkb5np4bkpsb948y8kpvw1pyvkx8rw0a0rvkxqzxr98ng5nq80vw6";
    type = "pom";
  };

  apache_10 = fetchMaven {
    version = "10";
    baseName = "apache";
    package = "/org/apache";
    sha512 = "0kmva6f2q5rq7rk9ljwn3rxa4w2j7sjkxsmvambzqpj61cagdnq4vj9jk0xxx8448kqckdh5w2xkr5lr33sgfl67jy9l5h2s6h13v6m";
    type = "pom";
  };

  apache_11 = fetchMaven {
    version = "11";
    baseName = "apache";
    package = "/org/apache";
    sha512 = "09v6sghdaxinrk3pnpnc36x24z62gqn65v25q83mc0q6n49l0xir55xk21qzc8kc6hrdr9khnr7jxkqz207cyv6wky6sy7c3pqg0na0";
    type = "pom";
  };

  apache_13 = fetchMaven {
    version = "13";
    baseName = "apache";
    package = "/org/apache";
    sha512 = "0sf86l1457wwp8czg32xhh96l5nlw8v84lbi59nfdxxzcrsn8b1ysgwda3r1ck0d86c5gjmh3qg7kbwlrspwa71w9zn9sby3bszj99v";
    type = "pom";
  };

  beanshell_2_0_b4 = fetchMaven {
    version = "2.0b4";
    baseName = "beanshell";
    package = "/org/beanshell";
    sha512 = "2xwgqmfwli40lvlgjx00ki5zm1290jhjvqg7wnq869kxkw9iam239zxb0jz46jcpbgy10qg6sd86cjw5g38njywcz33501f6byd0n3w";
    type = "pom";
  };

  codehausParent_4 = fetchMaven {
    version = "4";
    baseName = "codehaus-parent";
    package = "/org/codehaus";
    sha512 = "11dacs4155xc3rn3crdayg1yp15abw81lbk6qwi7207009rnyk1kxvs56am9pllkybgja53ri0k084k2ppp4dlhxrg6w3zccbafxlgp";
    type = "pom";
  };

  doxia_1_0_alpha7 = fetchMaven {
    version = "1.0-alpha-7";
    baseName = "doxia";
    package = "/org/apache/maven/doxia";
    sha512 = "0fg3l7dyi0c7r1h9rzjn23gv57kc67jpzlcji6yh4nawp3byfbz1rq8wnbj3av3wd29v9h2ff34p06ia9wxbs8q3kz4xy31w7sw7fxg";
    type = "pom";
  };

  doxia_1_0_alpha10 = fetchMaven {
    version = "1.0-alpha-10";
    baseName = "doxia";
    package = "/org/apache/maven/doxia";
    sha512 = "3by91czdkjn4myc6xwzap37ydmhvic4myr8p2zflnpawrph00jkz9pivd84k2qykvmc5gxzbmklf1inwvkq1f5bsyhh440mlvsfsn1s";
    type = "pom";
  };

  doxia_1_0 = fetchMaven {
    version = "1.0";
    baseName = "doxia";
    package = "/org/apache/maven/doxia";
    sha512 = "3z04h87dwn5panpr68ajzflw5n4wgi98isl5snz6vrd2vz9744fdqggmn6698wljw9h4pzkvjyrxf9b7w4km6w7kma28akvn951vw99";
    type = "pom";
  };

  enforcer_1_3_1 = fetchMaven {
    version = "1.3.1";
    baseName = "enforcer";
    package = "/org/apache/maven/enforcer";
    sha512 = "1m84z5x2gxlbj9bl2jrfzh26pl7nz1d79sv72clp565z4lr2r1abih2c7aigbd95zik948dqrbh2vzm7vp1iv0d23vk89rx4nmfg0rv";
    type = "pom";
  };

  hamcrestParent_1_3 = fetchMaven {
    version = "1.3";
    baseName = "hamcrest-parent";
    package = "/org/hamcrest";
    sha512 = "1da3ivp9n1h3hl35vhgd7avi4xh8p0802qj7xrk93gbz01s2av28p6ycdwiwp7kja0151wm5jvbgpnkxd8azqwkh7dh83w22k7jpwh3";
    type = "pom";
  };

  maven_2_0_6 = fetchMaven {
    version = "2.0.6";
    baseName = "maven";
    package = "/org/apache/maven";
    sha512 = "2k58pvcrdc52zsq6id4vl8a45srxllm2m49namqkzix4356haphk3i06px9jcc2cmkqw7bcpqh5xvvmkds5vhp2b9y9b0i2lcfgx8jw";
    type = "pom";
  };

  maven_2_0_9 = fetchMaven {
    version = "2.0.9";
    baseName = "maven";
    package = "/org/apache/maven";
    sha512 = "2b3wfqxbg0v2lm82a7nzw8wzw708isfrnzriy90bk89dhnj59qzpgvwrjbhs26a32gnpii5ivivh1msq51k1b7j5knmyf0hi1v0blw0";
    type = "pom";
  };

  maven_2_2_1 = fetchMaven {
    version = "2.2.1";
    baseName = "maven";
    package = "/org/apache/maven";
    sha512 = "2b3wfqxbg0v2lm82a7nzw8wzw708isfrnzriy90bk89dhnj59qzpgvwrjbhs26a32gnpii5ivivh1msq51k1b7j5knmyf0hi1v0blw0";
    type = "pom";
  };

  maven_3_0_3 = fetchMaven {
    version = "3.0.3";
    baseName = "maven";
    package = "/org/apache/maven";
    sha512 = "397qqkh9qd2aj346v4nvxrhaqz6k75l5xnm1xcqd0d4mmxg0p7jlz54yzkshqli2w5df9f7p8pavpkiw5xkl8ipxmp87vfcanvkx4x4";
    type = "pom";
  };

  mavenParent_5 = fetchMaven {
    version = "5";
    baseName = "maven-parent";
    package = "/org/apache/maven";
    sha512 = "1810h5ziij9awpf2c6sgqlwd93dd3c54rxbnjxar97idw2zkmwqfxvxi74qjcpbqqam3ypxb893k3958jmhbrzmwhwbkhxyyiqgjsx0";
    type = "pom";
  };

  mavenParent_6 = fetchMaven {
    version = "6";
    baseName = "maven-parent";
    package = "/org/apache/maven";
    sha512 = "2z9rkv875yx64mpbf1mgyb3hcxqbhr0ndczwqlmkgd05a679d4vyi92fndaz1bcfwc5bmmxf4s6zrg58swv05j2j9d6vqd2b0x385dq";
    type = "pom";
  };

  mavenParent_8 = fetchMaven {
    version = "8";
    baseName = "maven-parent";
    package = "/org/apache/maven";
    sha512 = "315cgnn7mvwq5kyrln3nw85x3893zdd4dg267gk9xkig1mwjpa86l6yyd6qnrwxywcrgn0wmn2l781yvwip9rys4dd9jmbma2qhzapp";
    type = "pom";
  };

  mavenParent_15 = fetchMaven {
    version = "15";
    baseName = "maven-parent";
    package = "/org/apache/maven";
    sha512 = "390z5v0nygsw075fa5jzl5baxb0bripiiy6arqk550zlg8dw8mcg6cyscwnh3zw4gxyr1qbcy0v8wsj375xc65i2agkzg1qbv5z6xxp";
    type = "pom";
  };

  mavenParent_21 = fetchMaven {
    version = "21";
    baseName = "maven-parent";
    package = "/org/apache/maven";
    sha512 = "2dph51qjkmh9sixd12rgxhrvl3w5r7nmr4n3ra4y1lifml6h0md0indj3qw4lxm0db811p3hxf2f9l0gf6w4q5ypjp20lk9ia2xm5s0";
    type = "pom";
  };

  mavenParent_22 = fetchMaven {
    version = "22";
    baseName = "maven-parent";
    package = "/org/apache/maven";
    sha512 = "112xv5inpan05vkm12g2lpz37pgga1nm8rar2bqhibvwljg4yv1myx8z99g0nkd3gzbgw5098aagm006w6bnmwsibwd1js8is5d4r88";
    type = "pom";
  };

  mavenParent_23 = fetchMaven {
    version = "23";
    baseName = "maven-parent";
    package = "/org/apache/maven";
    sha512 = "3c6ydqi3sf5aq3aj42kxgrjpcf8wpl0rf6hmr6vkas04w0h4dyvjb78ipyxsqzqgzjm6cmdfhxzx8hjb2lwvy3ipf1x39j6cj7dwdy8";
    type = "pom";
  };

  mavenPlugins_22 = fetchMaven {
    version = "22";
    baseName = "maven-plugins";
    package = "/org/apache/maven/plugins";
    sha512 = "14xy4s69dvqllkspc5b8q1gdbi0wn494ghwcdfcvjzvgczjhhxbr1h698amv3zmg59gb7liz77ws4vmcar8j9lazywcv13cy1myiywa";
    type = "pom";
  };

  mavenPlugins_23 = fetchMaven {
    version = "23";
    baseName = "maven-plugins";
    package = "/org/apache/maven/plugins";
    sha512 = "1vh7izahb4sskja66hqrygv1r8iwpl97kp65yx6z3fnm761brag89fdcl4jl9hypvm57alf283gvq9rsy5kqnqcdki20k5vw26y1b1a";
    type = "pom";
  };

  mavenPlugins_24 = fetchMaven {
    version = "24";
    baseName = "maven-plugins";
    package = "/org/apache/maven/plugins";
    sha512 = "07flf37pkkc34466bnzi4rfwdlgvd3ydasm39qzy2hybxv26306zrhipglmgsjvd84z07dscij4n7qdd2jkx9hrkm900hid4xwvxzrs";
    type = "pom";
  };

  mavenPluginTools_3_1 = fetchMaven {
    version = "3.1";
    baseName = "maven-plugin-tools";
    package = "/org/apache/maven/plugin-tools";
    sha512 = "07flf37pkkc34466bnzi4rfwdlgvd3ydasm39qzy2hybxv26306zrhipglmgsjvd84z07dscij4n7qdd2jkx9hrkm900hid4xwvxzrs";
    type = "pom";
  };

  mavenReporting_2_0_6 = fetchMaven {
    version = "2.0.6";
    baseName = "maven-reporting";
    package = "/org/apache/maven/reporting";
    sha512 = "3bi678sg28yxhlby4d3a6mq9fhg1qnjb57kbkhi7dfx9g0c1p6cxhg8cixjz9wv31lkjpspbpp1fq0z29a93lqrjqczlg8a7i1sg554";
    type = "pom";
  };

  mavenReporting_2_0_9 = fetchMaven {
    version = "2.0.9";
    baseName = "maven-reporting";
    package = "/org/apache/maven/reporting";
    sha512 = "0cg49pq6rvk7c84xwnpq2p47b7y973sy9qfgzcq06bnrqm6cj26h8k7d9kpp3q3rd2hlw10db4sjfx0crlai27cbbz41i5m22lq21s5";
    type = "pom";
  };

  mavenSharedComponents_12 = fetchMaven {
    version = "12";
    baseName = "maven-shared-components";
    package = "/org/apache/maven/shared";
    sha512 = "3f2pifiapx09h3wv9lglm0mkd9gid268lfz27jhqb4ck2yxna31872db7cj5c9lsg0pl2l3bwgp526whq14zj2qffqxrdq8mn9m0rhy";
    type = "pom";
  };

  mavenSharedComponents_17 = fetchMaven {
    version = "17";
    baseName = "maven-shared-components";
    package = "/org/apache/maven/shared";
    sha512 = "3f2pifiapx09h3wv9lglm0mkd9gid268lfz27jhqb4ck2yxna31872db7cj5c9lsg0pl2l3bwgp526whq14zj2qffqxrdq8mn9m0rhy";
    type = "pom";
  };

  mavenSharedComponents_18 = fetchMaven {
    version = "18";
    baseName = "maven-shared-components";
    package = "/org/apache/maven/shared";
    sha512 = "2qqabrvgs4kb14v28qkfwj16n715mj5mh4m8aw0dybi5igmrvwh1d8jsjggdfbh929m6499w8x5s6aw0gbzmfzr3wjkz54dqxnm49p0";
    type = "pom";
  };

  mavenSharedComponents_19 = fetchMaven {
    version = "19";
    baseName = "maven-shared-components";
    package = "/org/apache/maven/shared";
    sha512 = "1na6rh2mlwq6yrg7jxxnkcjj4ki0lqcihwiq2cy2ygsd6q0z8fn755frrd1j1jvd5dnh8jxjqp1m5mpwwv13hxhy8lmq95a5pp2a2qh";
    type = "pom";
  };

  mojoParent_32 = fetchMaven {
    version = "32";
    baseName = "mojo-parent";
    package = "/org/codehaus/mojo";
    sha512 = "15pzaqpdcr8c2w2b2ms3qc5d3r0flmzqav6h45nmg1l8nv7529lp6dkilhkwqag1i94vh8dvqnkxm475j9v2hxmz981azrvz7984z8w";
    type = "pom";
  };

  plexus_1_0_4 = fetchMaven {
    version = "1.0.4";
    baseName = "plexus";
    package = "/org/codehaus/plexus";
    sha512 = "22zsqss9aws73zvgqaz1brnvhk8bqn0flzd644nikprbb9dh1jyv1jig7xaxj942wq1w8h6ybx6b3v1ysfr8kw1z70sb5yrb4zd4kkm";
    type = "pom";
  };

  plexus_1_0_11 = fetchMaven {
    version = "1.0.11";
    baseName = "plexus";
    package = "/org/codehaus/plexus";
    sha512 = "20fb1yvg26wg3lih55m8m4i1idiffyg3jlkvazmxqqvnahz2llgd5cfvqcrzg8lkinnypr4ic5glci4lza46k1sfl5nrviyfx0n7kgr";
    type = "pom";
  };

  plexus_2_0_2 = fetchMaven {
    version = "2.0.2";
    baseName = "plexus";
    package = "/org/codehaus/plexus";
    sha512 = "095kxnh9238wlnxsbsl7wj3zsp2ijwx8p8bvbmsvj3iacw9fsvddv263j485zfjf4ipvp5dwqc3sc8mqkwbhx1qj7k1x1hj14nl6r8z";
    type = "pom";
  };

  plexus_2_0_3 = fetchMaven {
    version = "2.0.3";
    baseName = "plexus";
    package = "/org/codehaus/plexus";
    sha512 = "15adqpm0gz7c0jwjd4yk0k8h4h7vnz15v1fdmzb6rgs6avl1dx84r5l0fqs6b02kw008rg68inii7nl4m5xwqrj807wr8qzrjm02cam";
    type = "pom";
  };

  plexus_2_0_6 = fetchMaven {
    version = "2.0.6";
    baseName = "plexus";
    package = "/org/codehaus/plexus";
    sha512 = "07rrw1yldy4c2qvwv3hcf9rdbr0jf57qsnnv2ai9fajwhjyjkgjixm2zlsid41bm2w8hacg9crzy6nfz8yh1sdh5p767niy9jripq2h";
    type = "pom";
  };

  plexus_2_0_7 = fetchMaven {
    version = "2.0.7";
    baseName = "plexus";
    package = "/org/codehaus/plexus";
    sha512 = "2ddbjp60y8g7n56hya5qa59f980a8sdj0d1dicv3na3pbc6k4wgdrix78lgg32sp4fzmxl7fyzw9gy3z2vpzf65zkj3c9yh030jcysr";
    type = "pom";
  };

  plexus_3_3_1 = fetchMaven {
    version = "3.3.1";
    baseName = "plexus";
    package = "/org/codehaus/plexus";
    sha512 = "1q1p0sfzkhdpknaf0ysq7vzd0qip9q86z62nwamfh9gdsp7lh99kh6hmxav2daha462c3jra6clfniyqrbvs07jwjhf4c79rwhnqc2q";
    type = "pom";
  };

  plexusCompiler_2_2 = fetchMaven {
    version = "2.2";
    baseName = "plexus-compiler";
    package = "/org/codehaus/plexus";
    sha512 = "26sr1hg214qf65nym85viv1z4nk1bgqahx7n4bq3did49s9ymgz2c08vw7zdlcqws5jndz9n2xlyq285plgv3xx2mxrrsi2r24zmw29";
    type = "pom";
  };

  plexusComponents_1_1_4 = fetchMaven {
    version = "1.1.4";
    baseName = "plexus-components";
    package = "/org/codehaus/plexus";
    sha512 = "02kdl9z8nz26h4qf9mrdm8s1y2gy1f57n825yy0y3qifavlv51k2yxza7mjsdl1dwrq84c4qlj79iqlisnhrppfy0ncbbblnbir1yln";
    type = "pom";
  };

  plexusComponents_1_1_15 = fetchMaven {
    version = "1.1.15";
    baseName = "plexus-components";
    package = "/org/codehaus/plexus";
    sha512 = "0lfzdq1wlsnkiapzjs8cqi2kzkaw9lfjhdhmf1pz2x83m5njfx2y59v14wgcs2k4cig8kjr45v4qnmd7mp03k8gginzflc1qi1y7yv6";
    type = "pom";
  };

  plexusComponents_1_3_1 = fetchMaven {
    version = "1.3.1";
    baseName = "plexus-components";
    package = "/org/codehaus/plexus";
    sha512 = "16bnfja035zb508f340y64v4vk7pkldn8bvnxvbk0grk8a76rirsn4dl60x3hgmasgkb0y75gr9qp4y72m079klhgg0mbvcfvslkxqb";
    type = "pom";
  };

  plexusContainers_1_0_3 = fetchMaven {
    version = "1.0.3";
    baseName = "plexus-containers";
    package = "/org/codehaus/plexus";
    sha512 = "39sw2lxlrgbj1zlf67qz14j53sxd45p1qmna5cfizqikrwiqrnb6xwdxr2rsp3h2kadwwpz6id2ls6x3hr93znkad404rg4lg11v9nj";
    type = "pom";
  };

  plexusContainers_1_5_5 = fetchMaven {
    version = "1.5.5";
    baseName = "plexus-containers";
    package = "/org/codehaus/plexus";
    sha512 = "1dzg3ry73scisq02p1c96rn04rvdpyf9v6cbvvmy6hvcaw11y8mmjwjnlayljhr9za5hhq5bwv2vssmp683v3qjr5750f9aa62jxw0w";
    type = "pom";
  };

  sonatypeForgeParent_3 = fetchMaven {
    version = "3";
    baseName = "forge-parent";
    package = "/org/sonatype/forge";
    sha512 = "20x89zl6k0wgd1gb6ysxm6bmgqxwyz3d7zyjn8bwzkz93k7lxnxm0k7skvha283q9ay4cd2vkjisi5avl1f3wvz89rrwg136gmdlksv";
    type = "pom";
  };

  sonatypeForgeParent_5 = fetchMaven {
    version = "5";
    baseName = "forge-parent";
    package = "/org/sonatype/forge";
    sha512 = "1l3nll0i5cpf2rh5f4gqriwy2737n9sccr605nx1swn1qafbxbvvs4jl7argdzz0mkzrr8sir7vnksm9a273vrdica9l35nxivm6vrx";
    type = "pom";
  };

  sonatypeForgeParent_10 = fetchMaven {
    version = "10";
    baseName = "forge-parent";
    package = "/org/sonatype/forge";
    sha512 = "3fpnvrxfkxpxqdsn6g7w1zyql4v0z9iqbjprhh4c6rldrbvq4h3yh7dl5sw4h7av516zhmb3bkc9ycfdr5gs34sfb6f6x5hk7qc374a";
    type = "pom";
  };

  sonatypeParent_7 = fetchMaven {
    version = "7";
    baseName = "oss-parent";
    package = "/org/sonatype/oss";
    sha512 = "3xk0q7y2kdarr3l42dqjzq9qz1r840abqw9zhvl4gpc8jw5xcbqd781fp8z41i3hrkyaf740f2kppji9l77ci7f759d5s9yg4grbc33";
    type = "pom";
  };

  sonatypeSpiceParent_10 = fetchMaven {
    version = "10";
    baseName = "spice-parent";
    package = "/org/sonatype/spice";
    sha512 = "0gg2cxqvfmg6jk7qi2f4hcgskpd1ysnf1d5vay8dza40wfbk2vy7qvhgjhg55dpbjkadmsj483hg81qdzwqbxmagd2xr9j9062hbja8";
    type = "pom";
  };

  sonatypeSpiceParent_16 = fetchMaven {
    version = "16";
    baseName = "spice-parent";
    package = "/org/sonatype/spice";
    sha512 = "0awfi8vf4xc5c9510sas7xqlik4g8ljivay372cksvlcwlgyrgliikak0xxbxj72df5b9jzc9fzvjxd9rlllnnlnm4zllw5p2hakb0g";
    type = "pom";
  };

  sonatypeSpiceParent_17 = fetchMaven {
    version = "17";
    baseName = "spice-parent";
    package = "/org/sonatype/spice";
    sha512 = "1jqqp5xylm9bjz33wab7mj49xqczvkhpp4aysrcngszxmil61kanpjmn5ks5r0hq4waj0bqnr91p2p9a7ylqnqjs6ib1x9psl5c9cyw";
    type = "pom";
  };

  surefire_2_12_4 = fetchMaven {
    version = "2.12.4";
    baseName = "surefire";
    package = "/org/apache/maven/surefire";
    sha512 = "1zyppjqqwpzcp16g7v49r9fsgdvrny325r583kpis5497ic0qbcczxn53x7s1hnmhgcs33dr0k3alrwl7m574lm2qdgj0s8x18pl6gb";
    type = "pom";
  };

  surefire_2_17 = fetchMaven {
    version = "2.17";
    baseName = "surefire";
    package = "/org/apache/maven/surefire";
    sha512 = "3yraw37xwayyrvwa62y6li3wbzrha08j389psz16j1dawxmg78zlm2x1jmgz3nzdb60n9kk143606bgs3vrf7ri9d5pwkg9lvw7hk92";
    type = "pom";
  };
}

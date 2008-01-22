args: with args;
let
fun = {lc, hash} :
stdenv.mkDerivation rec {
	name = "kde-l10n-${lc}-4.0.0";
	src = fetchurl {
		url = "mirror://kde/stable/4.0.0/src/kde-l10n/${name}.tar.bz2";
		sha256 = hash;
	};
	buildInputs = [kdelibs cmake];
};
inherit (builtins) head tail;
in
(stdenv.lib.listOfListsToAttrs (
map (x : ( [ (head x) (fun { lc = head x; hash = head (tail x); }) ] ))
[
[ "ar" "0hpbbi0l9w2l61hcj01j22yb4vcgj09q00ckhvkhvzy4zwzdmsvh" ]
[ "be" "0xvy4a9jjib8qqy18y48r8np7400wa7w6wj10hzdvs4gn2a4cqm8" ]
[ "bg" "1zm44fl7r892r5rpx1v0zw5bsigqwfhyq7hyg5n3j19lfvnrk5lc" ]
[ "ca" "0kvgin92663g7v0yk2fxa5j1cr90v4hp6255gqmhimlp1j4mzcpk" ]
[ "csb" "0iypwx8jznadqwl73094n8ndb9xbi4ff7pj6im74r4z5jl7mnx4w" ]
[ "de" "0dd6p43hyd7jid9yvyw6ich8x84mmg1x4qphzs4ms32j1yz1ifxz" ]
[ "el" "0cr4fm6bnai7qcpbhl3p06zw3ggqsvaf9xhmivxpc70j4b6didni" ]
[ "en_GB" "0apyx5yl7yi3hp77v21y5dfqlb9mbx79wjk2pnzc16j8rnalq4a1" ]
[ "eo" "032y966j6yb1wx6c4pp41zy7jl2rviryrx069viwm2nyxnclq4lg" ]
[ "es" "0m2ajgdbkksvhmvdrz35f60p352w1bv01dy9jsayaahkmd9jzs2h" ]
[ "et" "17d4jm91y4glh5iphml6pg7vx7k6wbvjnp491lvs4ipg2p6kwdn4" ]
[ "eu" "0zjlg26cfylmf6r6lrnjwnmvzqh9gavip17vpq3py6pk712p1a6z" ]
[ "fi" "18yxf6gbiz09yn2ym20qss0y3dcggmg7qfqxz5jcb99bw2szpfl0" ]
[ "fr" "1fx8yqjdjmgis1hm0qva54q3nl6xwyzamv8n9hzldjab4nblr9hm" ]
[ "ga" "0j9qipqzxsnyw52fi332rdav7jxcy9dgmr5nsxbmpm8cns4g5lw6" ]
[ "gl" "0591x9ycj35adr27wcy2slzk4iyni0gvy2f4rqaskkjmrypi284x" ]
[ "hi" "099lihyima3fg6dvgrafy3yjzij28rx42hy0sz3z9cvy6adb4ch8" ]
[ "hu" "01wrylzy4gly1pb8614kfc2p1wr48ikzjszn5gm376za3fhjf0wh" ]
[ "it" "0d632q1y117zs6fibsavwx581cxbar6p3ih4q3wzlk254lr7rxyx" ]
[ "ja" "055dqnxnn819m7fshcwpibaa750dsx1ppkf1mw8jq4sngrc8r9k0" ]
[ "km" "01bkbw967rsb8grv9xd9nyn6ij5arr90l3x4ry0wi9syglng0dwy" ]
[ "ko" "0c60ypydrkbic6hp4rncadmchmhn0b012kgq1w69db3w77vc20sa" ]
[ "lv" "1b8sbr4fl2250mpf8ms4f8h9cbvgwnx0604q498i4cxs1ja5mby1" ]
[ "mk" "1nb8f092jnwazyg6y3482gfar7rrxf0i0wisgfm7rmydblb8vd6b" ]
[ "nb" "007n9r75ig6gx88kdj40f3rccb8z1avvp9l6g2wr85ysfj09qs8z" ]
[ "nds" "1mhmrkkldkv8gd5rcsyjx0bckacgn2m2fbzymndagd2sp1617hjc" ]
[ "ne" "0r1hnkk4zf111v3py4zz292d5f51wjxyscflm2fy10s0j6a282jv" ]
[ "nl" "0rqzrnninv3y69waibi8p9haddyqqir0sagajn20k7zrapjhlwg5" ]
[ "nn" "1s19ybg8spg3ivc5h0yqd36ry39piwb5a7q2kfbhhv843pgs1sc6" ]
[ "pa" "00vc84gwvq0xcav28h2vv80j9p80y19mq2mfgjzdx7y63qwqbjkh" ]
[ "pl" "1xybzvfih1m37q54ihqmcsmdqk8piyrn9crwqybslvvklqrmy51c" ]
[ "pt" "1kl2ap044li2l48vyym4s9sjybs2vx2fadnk7wdhykzxfg54y12n" ]
[ "pt_BR" "15ampx9rhrpqxn94ndmmgkcmmd0hxh12xiph312kf5r0xsinxdpg" ]
[ "ru" "1hydlhcpa2wcp0zn7a3972bc8abscgvaw077vjhmvda3zwsmcfsn" ]
[ "se" "0r3q20xxdqj5kym1hx6vz7prir3nspgbrrrk9aamhkwwicy03mf8" ]
[ "sl" "1xa7i7mngz1gpa0hddy1cbkkxjrrb7wlhr8jbbc7n76ll05anh7h" ]
[ "sv" "10b0f7i11wqjyizl1m6xwr0j8fh1fdap88bmvhxvj6yzmzkdrp7v" ]
[ "th" "03a1hi6n1dv6ak3i84gd2jv199y17sq9m4rwpqwnx9zcnv4y453g" ]
[ "tr" "19h45qxng8qy71h3z1s19j25mm9px71z15ifvq1px47xii34hzdz" ]
[ "uk" "10fv27xh737rvp0ps1x6lm5ybajxbwy2998dsfmkq0zh3j99yn4h" ]
[ "wa" "1sqmki4sm0mlmvqynpbjbl6xmw5h1dcp7rcmnxsfl4qnxgj3al9x" ]
[ "zh_CN" "1h7r1bzaicvjad8k4nsmb2pyk11crpa82jhw2whk1136bjh0f9sg" ]
[ "zh_TW" "1yhb7c9q6fkj4rj4mb6r37fhl3bz4gcsplhd17z02gryjmn4sdjc" ]
]) // { recurseForDerivations = true; })

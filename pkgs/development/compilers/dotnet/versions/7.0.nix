{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    inherit icu;
    version = "7.0.1";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6f0e5e7f-cf41-4ece-a728-eab7894157cc/b043910ee98786617d99cef8e8914c23/aspnetcore-runtime-7.0.1-linux-x64.tar.gz";
        sha512  = "8265cc0f35591ba58b4c6e12378048b72d1a767c56fe29fe9b495c4ec537ed43ee30890412ae2d52b15a732bc164894d10fa8a59407073d41ac62a3fe6254f81";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e3d97ec5-f36c-45e5-bd0f-c58b0c468ec2/0b97b0983d826f854d9328165393bf1e/aspnetcore-runtime-7.0.1-linux-arm64.tar.gz";
        sha512  = "e80bb0756ba23ebeff96b5e97758a4c74f2bea29b718860e795d62402604c42ec9b544e89e94662a037bc0a68a967b93a2e6321dfd3c4416cde47cf188f67186";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3d8f8533-29b6-44b4-9b12-12dd99e8380a/70eda23293055dfa566386c4b6e71ebc/aspnetcore-runtime-7.0.1-osx-x64.tar.gz";
        sha512  = "ce0f100cb4494c6133e2710ed92da8c7c7e7fd5626dd22052d9864c22ef4eec88b1418ce7357cbeea4349f12672efa3fe9bae5f3d41614b8fd70930b872844b5";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0c8fce04-9135-4e2d-af4f-ef8b23a1e467/67493d21915b734225ded1ac7c311005/aspnetcore-runtime-7.0.1-osx-arm64.tar.gz";
        sha512  = "d804532c874279653fc329f23d246dd76aa375acf508de141e5c1d9d89e353f7085e53f1898cefd1d21d4bf98a719d658207b9d08c35bbc2f23d2759fe7cccf4";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    inherit icu;
    version = "7.0.1";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0b330412-234f-48c5-957c-c3c8c854a400/8d9a07cc153fd16a828d78c136b47e6f/dotnet-runtime-7.0.1-linux-x64.tar.gz";
        sha512  = "db79b221f6bfa4d56fe0e2b7c237612bd74a81deb18f038ab7226b9e06eaea6e90909f1493f0ab4cf7778b6544b8aaa1295ece1c4a9f1fe39ca44bbfaced46c7";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/038c1cc9-fcd5-4a0e-9547-acab08b0a4ee/c56e6ec6012bc6e9f52897166d543872/dotnet-runtime-7.0.1-linux-arm64.tar.gz";
        sha512  = "53e9b03326c2fdb8d2366a97f3cfbeca4f0f497b82cf665d5d4543f5d0fa8a177c53e8f48597f79072e962e3c7ef6baaca96143c2f775be52071e8ebbae88f34";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/45a4345a-ed55-49a9-ab5b-4e85e94f489f/54011a3f9000b22ecb3a823f8f1a6f7a/dotnet-runtime-7.0.1-osx-x64.tar.gz";
        sha512  = "bec337234d04da6530437bd13ec59e0112c4cf951402e0a5ff79c60c93498701e5b5abc6dffc5afa5ccfb214eb879d278ee5beaac8f4f7043ae183157a7ab476";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/14304a5c-0fb7-42c4-b838-e5e9c9dc9d16/7da30cc174d04e0e5d3de1a3bb134eb7/dotnet-runtime-7.0.1-osx-arm64.tar.gz";
        sha512  = "2a4e583ed1a2c32de6feb25019eb9fe4fbe26d0cc1ab45a2c7f93db61ffdeef86e37a8af5b36fff0729d649743206986374173dbc0db84d5c0f13b308e40c96b";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    inherit icu;
    version = "7.0.101";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7fe73a07-575d-4cb4-b2d3-c23d89e5085f/d8b2b7e1c0ed99c1144638d907c6d152/dotnet-sdk-7.0.101-linux-x64.tar.gz";
        sha512  = "cf289ad0e661c38dcda7f415b3078a224e8347528448429d62c0f354ee951f4e7bef9cceaf3db02fb52b5dd7be987b7a4327ca33fb9239b667dc1c41c678095c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/caa0e6fb-770c-4b21-ba55-30154a7a9e11/3231af451861147352aaf43cf23b16ea/dotnet-sdk-7.0.101-linux-arm64.tar.gz";
        sha512  = "b0874f4167e9792802b46a7ddcf3a7f7bf7329eb3699d4308b1cdd45ef32678962bbd0ccfd186e48e11cac3b198c4415ceac2f5e546d5fcdf0cecb05810863f7";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/58c27f9f-f988-4a42-be1a-0747657952f0/32c855c8c0ff149e4b3662ff3bc3e632/dotnet-sdk-7.0.101-osx-x64.tar.gz";
        sha512  = "f08a2137c37386ed9408106d10a3bac5f1a12dd3535e20e4384a96193b82fc27c15ba0ccc47e9bd7a12e533a3e9f0e220a08a220887cd12c678fed476ee12bb5";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d9df94f7-3ea2-41b6-abde-dcb9caa87056/9df759093dcdbc1a1b98feede2da8aaa/dotnet-sdk-7.0.101-osx-arm64.tar.gz";
        sha512  = "586b5a8f32601ffb8466e0135561a02105766388997bab92a428b4567ffca961dba540d4f6fe237f3a4ea068dd4bf3c9050c8557c0cb7e25f4c020fe0a62377a";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.1"; sha256 = "11r444zxpaaijcxqdnc8vlm9g3mppkx8k35y7bjdinbj998jyhlv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.1"; sha256 = "1dl7yzg9a9pq9jrbbipp055laq4glk7wdwhl60iyvj7gr2icpljq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.1"; sha256 = "0psndv4171db3vqqqqvb3mca94qx411hy6cllrz0d931jydcdlna"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.1"; sha256 = "0yhjzj801xbgawi3qs87i2yv64aqf82xa36vmn37bs1dp8ikjh8h"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.1"; sha256 = "1qlkw8jlsrgx47mbvkgdqhi8qhx2j4xjbpiiaxrm2k6cdrjqqrla"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.1"; sha256 = "05prp8fnbb59ydqfgxszb1n1xa39pynzyfwwnlpjfqn0hvryh4b6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.1"; sha256 = "1z0zc164vdcb1lf4jmrsqi261l6nw8bk82y112k4mwf6fcrfqjki"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.1"; sha256 = "1wakpdw6a0arnig5rykl6k33jwp1bm7k4cawdnqhzgvq9yrhnbb8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.1"; sha256 = "0cp1qqmdgya3nc8pxbvg9nzmxcqrv26v8jpl7fpr9wvswsdm3ywr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.1"; sha256 = "1w1m89b2fmgza8fggskm2mpz3pq6f9cskqvr5wf3538s0dm3zai7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.1"; sha256 = "0rg6rh71ja5slaxx8gzmj74q0x4sij5b0437y236abyph5x8f3df"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.1"; sha256 = "1ic0wbsbs917ab37f9a3w37png5fc3p5cqiw3z6zd7dkjlxxnvqd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.1"; sha256 = "0vpqvwbv2rzbim24aqz840si89h9xbbq5h6z8m79gn47ijw4awvz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.1"; sha256 = "1hc6mmvrzvm5pl9smvk8x9x5balsyqcd928js8291qq9pw7dpc85"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.1"; sha256 = "0j5d7gr7m0dcmzsnxbw6q65c58bryj8kc1qfmr0xd99yj55lnmq4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.1"; sha256 = "11s3r9f2zgdmjim8pylp7fwm4l3pd73l0lcfdfy9h90vz3wj9dzh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.1"; sha256 = "10ni736mgmkgm1j19y6r4rrmph1f079mbydfclmf546705ssvkvp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.1"; sha256 = "184pyrr7w4i616lf41w2y4f4m2cm2m2b087v1ry1walwhazrrryw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.1"; sha256 = "0hp3b1pfj5x2xfri8nyw5kp3ggqxgjcw7njiijxpm2yg1zj269a5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.1"; sha256 = "1qy27qq6zavpa9c71hizyhp6byv4vc477r4j9iwm4shvvpyp7aad"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.1"; sha256 = "1r83c0xixij72ll58v68yads7pjfmywx0ygffd8zjmz9djxgiip0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.1"; sha256 = "1kic306b2v7n706zw4nz788an3zl316i617fdh66zkqr43kl2w5v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.1"; sha256 = "1rmdq8mipx2agyn5m1y43s650vfjxqvr96ldcgvpggs8npab7466"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.1"; sha256 = "0rlqlh326ascnqw5qfx2zyf8mvgjyf3rqyg3j7xgw0w3bwlba1ip"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.1"; sha256 = "01370xwprc3m2xgz2fs217qnm35lg5m2hh81kah0hz793dhmqcfb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.1"; sha256 = "17y7mnnzb88bpldmakwz2jqyg49c2dwk7qn4s7w67ckmggaswh4f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.1"; sha256 = "0dx0j3fikadb0ydn4ncjqsvbz14ladgmpvm9zz3n4v2y5ry0pa4a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.1"; sha256 = "0qclazx1zyr324cp2ssdrh3640sna47fyl9rnxq63jkw3n5cl7hz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.1"; sha256 = "1jj9zrblah88m1f1vm53x4gdw5671gr4zdnra0vfawwzy8rbx69k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.1"; sha256 = "0myvn4yzhljm1kr5m1b3i0hxkzfrg4nbhv49413171vwic4p8n5q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.1"; sha256 = "0zj328ka130sya394y65bnipl3mpf8nl0mapap74jnqrhbki69a8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.1"; sha256 = "04n49c643d6rksxs09h383his9m5ljaz42a00fhzw1mb4pzm88a5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.1"; sha256 = "1il3f59nbwp9gvwwpwbv7kw7dv35kh2shj030vpykq9h6ch2k2rn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "1651k4klgaa2q0rpknq5vzn0wg8sq5snx1c493sz013gbzqpq5jw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "14n1zg5bhx4yc22c3razj24rbj7h0yxlwrwzgdi51ix8gzb7nzp3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "0pj24ma1533z90s96x9v0bya6macvp95ggpy0h8ixymav44fkk9k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "0ykb419lln5zdnsn9jc6kgy65wm58g7pyy11v6iycrpmbcpkb1m2"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "0754m46v1amvrvaq0yfn7lh08iwnknizis2n9qqkf0xpj32sqah5"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "0ir054hafvyf4s8fycz4bifdar9g0ss11r5dgq5m178xsjgfnhib"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "1dpbxsacbxlp6rbshdwvbrw31wz17bpmipf0svgps7py448xnqy2"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "00rabsskqgf8dcypyi48095zqqgayzhnx5zfxfa22i63cky54x0s"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "00xj1w3acbxjdasywngp2gnsxn16plf31v0vvjfwah38xzrw2qyx"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "0miri63x3fjnbliiq8724mc8bzj2kng1mss1x0rgq1rjgdb0bimx"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "1gi49a224p9slzw96607h2i95qnkjdj81kp9f2541cr47zvlslll"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "085jdd3fjj0mda4y7v6wyp21zvzg1kc21acljk8lk264cq6ckbi5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "1fpm8faqhh4s1y4qnm4byrpvq1zlhm1brpi7vg1w7zl4y1g3wr7l"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "1xf6bn2kacdz4qjdhnwbkp6lg7l8g6xjii8vgrnpq36jm62gc4kp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "0wbpwi7v0hxbn28xkqccr1wsl82qp2j41jd819cm7amaikvqy30s"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "0sswz7ly4g22gchqh9pg9vvrkvcnb1l49sbbkjs870cyvalid9rn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "1naqnqgw2r97q7nv5wfgdlv40g0x77fl8j777mf3plvq8y72r3rh"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "0w67rjis62ggjfail7ikx4j7wh4kqxp5fsfa9ig2j02fd63pgla3"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "0275280n8vipl3szwnk0rg0ziwvpn1pdppdpac41yq8wm8vcz6js"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "080k0ayvvcg5n31p360sygmvwjbs5597dvrnl0v61nml1xh3bhb4"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "0dgyl7jkddd7pz3hsvq46ia5bq3pm8ldszrb4ylcz0c1x04fk71j"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "0v90h8zcxd917qfqfl565ch0bxhlpr6fv6d11qbyxgankpxv39cg"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "068n96asl9r3546yynv47sw8rzqj51a9f5s6phnf44213kj43kbm"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "0ldnczqjs785vivdfy1va8lfmq4zakdi9s1lbz5cc9mlj4fxnzpp"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "0g3b4pjk4895ldix2ka1c9frgkkj0dy37i88z16sgdf9liszay69"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "0qr0c891sqyd4v32xpfhafycq8ix56my508jsnq58xfpi79flhlw"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "0m0ffmmjgf9sqj2yy4m9zijsy4y9kig5j28mrmgkhypbv310lhwj"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "1shp6ikrd2cck7jv0lxbpy5dq02hy8pihcqwn931zkrwcz54ci1q"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "08s3xxiqdfz980l85gvizwr1i4r5izmzll4543sr2qd8f2yldpdx"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "1i2xkjdp2szjbg4spczv8jv4kp2c9c172g2xqp1idsvbh3qmmi4v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "0xgjm43mbdj939l3kksmcs2haz7p0lyw9iw7nvvd82m9gi3lf85r"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "1g538a6qay31bk7w918rb2m5davxhvv69rhk1s7yizmsnh4ib5j1"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "0gjlk1ra5ihp7ymv4dhar9j3skcb7m55zjd1x734z5qxchvwzf2h"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "04lfhpy7k77vplwa2mpmynrwrw6m3k8qk7cb35xb7bdi6x736r6q"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "0p3j3xip46dnr04zrdb9s0nf6hx32k1p00xiawra79k9jwm49m9g"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "0jhy162fx1iy75iph5l03yvj04j3jhjlbfslvra4c4xkmy1dc6x9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "0aljg6nmz03d1wzyqdb2xhfbbrm93c91kqxj6y1f9zl7sx1ih9h7"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "1bq4bcc5p1b37b5ygbi4zzy3w4n10w7n36ghd08f24mqilsa1cq9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "0d14ppfhxd235qapgnfzxg28i9l1sz2rpx6rskc92znf86vr8r7h"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "0ghc0shad29864mx76g81q04r5wvk2kghlm3x9d59wj0z0afdc9h"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "19gqgvy18m8rwmgyc4pmdgzdrg8kxjqdhrn8d5gv0jx37yfk6mv8"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "1s2zq4lhs9wallnzwq60kd0f6pyp0rlasqhrdrias2yw4jcvyxb1"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "15kcczvqq7k3rw7l2hddhy8w0s4xyzars9fi01w7saj9fqzak043"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "17li6mdg3nbx67riypfz7s71nkp2gph5myalav3n3v1pnl2ddhiq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.1"; sha256 = "0xj7chxs3vcbas6sw1hydpvdri7snwvqc2vi06ll1jsy5nsp1z3r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.1"; sha256 = "04r740hqz53an4mww7w138qv14v1c0665829lf23zipqrrhj0am3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.1"; sha256 = "0hlw4d555j1gmc1gmpnqqwmmxm1p3dw5nr6z9wakmr8wbhlij9hp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.1"; sha256 = "0bavrg11l8pkvbxp5z3scvdi2knnpi2jhx2z2z00162kyvwsnbm6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.1"; sha256 = "1zbzc6xnbky56qc0sjdc6k4cmn764xnq2cnpxx85anxq7l4brf00"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.1"; sha256 = "189zljg2czvs4jaqfascm143j7mmpfvp19kr1m9z7nl55fa04mm3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.1"; sha256 = "0xpb9asinhck23y9lnpkk3iqj4j12v1fsp4m4j5dfc26ncnq86mb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.1"; sha256 = "0cqmpf8h8vwxzhfw5fg27xbs630dallss1pz1993bn41nq6f7ydj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.1"; sha256 = "10jqwp8fqy6mr4hx4vsn0zvb7rbgh800zh1csa6fq2hyk783vmii"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.1"; sha256 = "1h0l6b79878ixr96yr9gpinjn65l86kr15jrl58dl8dzq5dgkiqi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.1"; sha256 = "01x9aj4010n9j0lspsczzqirbp1yydqffcswxwgrfrqg1yjhp687"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.1"; sha256 = "1w3hrd6c6662972sx8swhw66b1j2rgmdxva221n8c3bl64y9yrcp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.1"; sha256 = "0vqi937b3qzcj68cz6r9pd9ad13qkbhwdfapj1s55glwkb0a2rwn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.1"; sha256 = "02h3186ysfgqr9mrg8yznic27s82k43va4dx1bfy6rjkq8s2qa5n"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "08cw0dgskfvb27y29d4vgmz4z3yp8fkla12h31py5d499443yaa6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "062kb0cw912l8z1aymsw9sv5v9lcn1j5ynqi8p6jbm4qz4m5kmfg"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "0j8i1gymlyr2zg28zml0pgg0ziv35wsvhiixjqy40bg1w77p14wy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "08cx11n5m9iv6nashba76m0xz28sh0mc74vbak2xnskhmkapv42f"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.1"; sha256 = "0c4y89pjw5gdla0lnl95xxj3gz5jhxnh96h31f6c1b754f7fcjiq"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.1"; sha256 = "015l0vin9fwfxyqaws8b7ikbdj949gdrpgb01sxb6zk830y27n60"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.1"; sha256 = "1v04f0g159x7di9na4ydkljwijz7ly4v1ws3n5h6m0yf5r5plv5x"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.1"; sha256 = "0v61px8250kzbd2dsl823m32g68j96ga3br1001x237w09qmpwjc"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.1"; sha256 = "0f572aariwr3mncgyhf015l3a3rj98j0xwlama9mvhaqjvj9pahg"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.1"; sha256 = "0bb22j0mld6f85056rnfb2wy3js4hq1f6lcxgfckb3lcpdv3hbny"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.1"; sha256 = "1gjbvjx6kf84gmwakazkz8r7sg61ls7n6lqkh4ny8py45nacr85v"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.1"; sha256 = "0sg4cjj235jwpj8kk85178qnx869xrw69abda9gfczkyzzfyww2i"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.1"; sha256 = "1caj3ipvszwz2xbfh8hmcp03b0swq2haiplvch5z1a986gp336g0"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.1"; sha256 = "08z02n5632qd7jhk3w5pwyp2lgaj0w7ch966vddqn7b11mzhrspy"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.1"; sha256 = "0s8ky64iwn1pcj3pb0myw0m9d07grxcy4f47aj7baplgq6l14z89"; })
    ];
  };
}

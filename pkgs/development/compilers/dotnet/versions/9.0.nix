{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.6";
      hash = "sha512-4cbMRgJ07eJMBUi8v3Ps9L+ntztvA9VcCiMvGSIZc7Tj4QZG6yW9PEVrks/X8AfjA1Rj1l8OTJaHykv6oRLZSw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.6";
      hash = "sha512-23ET/Y/1NCDNZWVnfMRXwoadsuz+pZrtZG2q1Woj/iZCkvei7zDgUP3OY5HVyHNRyT7y9TH1GA3smeEGRzxVzg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.6";
      hash = "sha512-EgMOEOOHwep0HuDkKqmUHPU5LyytjYNhKEck/jrk1jEuVOMM85gJ51A6V/D8HbpLMwZu6Xf3mun+X8FTQ8rBQg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.6";
      hash = "sha512-perSjdz+eXfLbiEiuKTpuwyDK6cY/Bb06nXrC5yyzyRSpOXCSTYReckhj905HsLcGhh/fI/f001oZeKkRapjNQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.6";
      hash = "sha512-Syea/ZRRC5TEoOHYOjTrPY5MutLowj/wNyVmfc+vpsjPKZ3aUONP8QtajyFGV2MiaRe3n0v9zICCahscDd0C7A==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.6";
        hash = "sha512-jZGye2/1bZCKp2pstHa7Ao9WTJvn0nkjW71T9GX1LXlAptkf36QFJhC/3Dty+XqJpsuxRsxU9A6Cjib0g3tCGQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.6";
        hash = "sha512-Nk3g8RsNxtG8hC5L4BT+VBuqNKo6RnCirF/9d1RjhhwpleMH9uQsvkyKhVm1wNodFORzQdAP+uUgdiKZ6eu/+w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.6";
        hash = "sha512-p2V2hOy/yqf3sCeoxi09m6WoZ/1B7iSM0NXXgcYqoE1G2bhv2FhAv2z2eg6Ynh0GYU07RfQHLwrxC2+qjg5xTQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.6";
        hash = "sha512-6A2zGQSBQp0K/Anld6WIXIeCEA0KwCgROQLwi81+NUz0MySjOVo06OgxG+svJeH0gGX4O4g4aP0G0mu5I/9sTw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.6";
        hash = "sha512-Ueh2AoWYf1xIq1GlKxGiWPdRWNTky6id6Nqkxz/tqWE1AdMw/aXQwK9eV6KVSy5X1uMtxqs9437d9Cw1wKGb3g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.6";
        hash = "sha512-Y25NMIMRfqz9xftyER4Ip9WTbBxmz418hDRIbnxEs/Rm7YTImMNA1spCXPjkYKNGuthjbMP0ycxcrIIP7LO9qA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.6";
        hash = "sha512-4lzVKIyc39LowT2BJZve13EsBC3bzbPGXC6h1233QA2ROXEVoEQw0xb8MRMb0J9PHR/RnPs14E1p9soDZ5eD+Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.6";
        hash = "sha512-ugY7GnQv+2h3a2huCseWo4twDkszWWLJ2QB6Y2pthaERkbqWF/+n6Xr0xLWVWQkI5hhsWZ6S2jOjrho2OAUi+g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.6";
        hash = "sha512-5BbS9hxja2XWQBNM2Wz313NevZUAt35dqThe7sPAGEYTvs33eEt5fCs4xPFxob8M8z0meFjwVrVodzzfXFodFA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.6";
        hash = "sha512-YE1DyntUFOnzuyhPn69dxyhuRCAlmYfMWDIGwolrV7mAa3wN2hgdTqK2bfUNdsT9Sw0lqk3W02XATfVolZ5aeg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.6";
        hash = "sha512-jL7rg+9zAfnGbJQXtoT+SQZ7U4Xg34As6oQwIG8VuR5wVynFdPUgXp1H3dem1EKG/obE6PgLT4MgJM1mhXNDQg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.6";
        hash = "sha512-saNHscRs66/1FgZ7tQxiSK7E3AqLheC3neSMAC2bvyKigvli2tHK48y8kiuvWoa7oPL8+yTOpN1Xgx7/vcy32Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.6";
        hash = "sha512-S1KSrW7+6q7M2fLLhXXTdrAvfa2E/LJnVuHVWMpGz+9ISiV8XI4iSW7ehrGiQ3pi13y04JkgFs3Qhug2tFONPg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.6";
        hash = "sha512-75DcTB0ssV5GYzcEuftwrQ8k2LyDB2e53SQpUyAbfM1oGduUxWmntm43OWcCNeE8t6q7eq457pHl5fwI1Fr50Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.6";
        hash = "sha512-3F7atPGjj6zBgdfWINFk02PVvvf90ldUxRHCGpvyFQW+DNmx7y/zqqnSDmM14eoVRZcVCRPaKCvPjfv1KNIlag==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.6";
        hash = "sha512-c8f2YKBlMf1WU5mgkDvfj2dC08ptngMc8KhcCpHRnOwPLMJUUA3luIe2J0pZ+nKBmux4Mt7t2QY8DUbmOrI/Cg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.6";
        hash = "sha512-UGSb5nYKfDFV0dsRbRMemfrw1qeYNusbd7ILPLVN+PH27ge9IjbV80PiJApW2q7GB2xN35WMhWiwrmE2Y2JsIA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.6";
        hash = "sha512-Bk+cjNd5fEgTB7FoXuUgV7ke/VMUDUnRryTq8m3wsnA7Il0RbjtFBW4Ut9RAKU1y3ZYs4ZN40rLgE4s0JvzHmw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.6";
        hash = "sha512-T8KyQcQtCWwWcwzuBKvPvHu5xHneYQ1RA1PNuWGk27rBklXmxt98icULTYpdDmcGqn2BQb6GlM7UWBYPA/VFjA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.6";
        hash = "sha512-+NPQTOSkxtMikAfdRvHUccbJSRjgmJqhviHXB6xr17ZubKpbHBe1r8/5BmpUgNedykJhM+yjuM5cG12sLQ1lWQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.6";
        hash = "sha512-i77xcc7KGxpX1Ydaa5R15+eNtko4CoIiH6HcwaDtBmnSeoLe41v/sp4W/OXlqrd+Q3a6UW481ff7n9odhgxsKQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.6";
        hash = "sha512-FBlNeLvbEAjmweRkAMyVxPuC2LorMXgVJmXomt3zqHmpy6JJzF0fVQuaIAQR9rPXwQxBNW08PmgXqRBf31i8RQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-ekkS3SSPWUzKC54fK5zDz8ZMe5kyLIK6l9mlFZFPuJ/mvbJ+t7YQmy97Lp/rcjUDC0z2SvwDcbe4rw0JNCJyDQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.6";
        hash = "sha512-/AhNE7lNbGsFfMXWk6/AAN5vpkaqrnwzTZJ59lUSba1onpCJS8ageZNZZf2vFLpl2JYuNt7qTgcBRTWZ1I0CEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.6";
        hash = "sha512-YBOl4EfiO8a9AIdr7hdbeHB4vu3HNQs60YKLakZnYGp+YYlY5VfOF+NMcAelrkbOf88HxMoKsPtV0WuQrn6Mzw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.6";
        hash = "sha512-ldmqB77CuVlSeYEvLXsOf8EbFgyDGNPm7hb23aweU0JEbpkYlq1+LhGMKavB67nckMhOkMWNJioWXP4+Cn02VA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-ka7E4MUOFjZyNVyglGgVhXWp1Vj0lyBUJ7b1aHgegcXLSvDP0GwNF66IBjPxz9PNZF4MxNJr5F5Ny8u6FKI/gg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.6";
        hash = "sha512-0hK87O2vVKwqG9paC9hsVCKOZqjEHcCrLhR1a4A/sbUqQo8B0MFKvvr/p0w5PFmiQmho9lriLWcJ9gImsSt1FQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.6";
        hash = "sha512-cjrfAzBmcTHSJno22YZG218HD1WjXe9CGVUN+sGBxP/c6fqGulOI5UDJJDmQ4FUV+rW0cdTre1DYLtWiMuI8Jw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.6";
        hash = "sha512-kj9m+09fQalBWgRwfaYThuTK7NFPtyad8X63jZ7gfj7WnqsqZLWdsBtNihaJVoNj94cHHVut3MItFfCWtpPfZw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-Usx2GTbhdsrrBoIDG5ZX1DUfDBJGVGtf85VlH3tX0YXBzVBVCJJPx7IfcmakG1fozurBhNpWiGXbglyzskySnw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.6";
        hash = "sha512-MD2n0rlApp3G+Ur2lMQLh1iQl6afbm1Q4KwZpB1zV43HaZgxBL3djW4cKFjDYo0aP2Bgn1ycoL5aab9aZti/5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.6";
        hash = "sha512-6qvqNn2PfL8YUY/CPyeZTgTTmi9Dw7w8aJrpn7DgpPVjnspb8vsuRd8T1Li2PTU5y6E8O3w6jetrdI6mgpX/Hw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.6";
        hash = "sha512-oAQ1cHbW8ZdXvraB09nbu1V4b1eUN7ZH71+yFX21t+1ArT5H8PVQ/hrd2K6WhDGFJBXlNjYT6Trlg+gbqKAheg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-ku6jYk5c0aPkZ8JpyAZpjyEJkIqNalrRl8TQUF8c7LGaFEzjR7jrTaiXUeEojl7FX07Jrmo5bCwkbi+P+rMbxw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.6";
        hash = "sha512-GSnfCxkwq7J1PdJaNcVSclPNOftPWD6m+CDwYdkxmFFcI7Qn667+UAqof/zTDlrWBKSEnQ6Og0I7ldHzrbyOKw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.6";
        hash = "sha512-mvNpFSjrYU7/PMBy98idjunaBKU5PolHyFXbYyVPrlMWUWSo5F5baxM5rFmD27tEJOEs4BFbKGGAIgjTl0dL5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.6";
        hash = "sha512-csGlXEfhrF2w3JUJr0hBgCRkd7jAjOhTY9jsNbl1f8TIhjepUH8q4dPrRrjBzXopRW3iqD+3oSetnS2/AxqIAA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-IFZ4+4RboQyHCLwSJ/4hWFkRbBez2rDTp00GUC7tQRjH3d2vPBd5GPu0joBod7YqmjQCDw+APwgm/LXuF02RBA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.6";
        hash = "sha512-P17+iLFLko8DK8zVsEwlsxVEsA2aMMdWpmEhTgyeHfG8uq5eOyMSTNMOWeOsDDpThNo+8U9d4xULnV46IRFwQQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.6";
        hash = "sha512-MWQXJ5QsswPxfykUi4gHJ2X4pnQ7ZWeIiGRx9mEWoZPV/NkC64DBG5KC9u9+hCluij6BZEFjwBjl0KzCuOm4WA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.6";
        hash = "sha512-eVf9gQ1qlT7uUVfYiSLpj1H/UnGqkSUuq4/evLuAxA4JHGFRpv/GdNmgMcM8nVTNm9KkQj4XtqoLy4iS3zNrmw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-nesIUxMmU5gIh8GRimFetwosmow5P5ij6USkbkM5f+iE/C91TbwZPrilv8Tix/Gj8OR2lOGlREhYHUsc+5H9uA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.6";
        hash = "sha512-noJBW2+TxZYce0afsgMJAAA//nxOWF+KASiQ3fPRpzZjeOGfdNyY6BcAt2i/DfVU5u/cqY0IwOfVBd6iq3dkLA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.6";
        hash = "sha512-DIJUSz/0MD3YBkhR17re92A9FGyu+1lhWJX4SkFdl7pILxSgJUqQNdZpnh2KssNWNbb5j0EtP9G3Tc2uUCH8bw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.6";
        hash = "sha512-h60P7+JXr8o1IPHe7pNxESjR8+pVvYT+AFaG5L8G9SIKVr+Rtt8P5rpgUXXLyydWDiarrRUdo52Dr4CXkc6Ojw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-aZgVLnZjLpr6oPPSDX6DiOAnZoDukSn5xmqkWj8c89iNXHRE1xK5yRNzwRV4fyWIE0tIf3EvoPOlzE0BpEBSYA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.6";
        hash = "sha512-rSpPx3elDDELL5n1c8teBQWlv83Z62cYRltExoAA3D/HB/YKcqHNjnQc/4XB0O40mP391+h9bfvDSkMdUc9/3w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.6";
        hash = "sha512-+/DAiKxDjWba4DRXmw1dfaK+FWA6foy1sGssWxs5eAw2wh+uROtGsKJrz4rf1k7d9KP6jF+tVsV0vb/bBi89Cg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.6";
        hash = "sha512-b3UuGcvJHlP9ie1D6YLwCabrhRYZjbhPxYe9vMGPUGBlTNIZUz7kdwNyIyCAWT/dQRqOKD2EoNBpV5CEIRoUIA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-9p0JQzftQn+daDgkQOeTc0y4zMw1XSwfDVU/0r8GVXJ7uGnHnQ7nLE/7ZYbKuEesq3POXWz6zXvQG6IbsAzgQw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.6";
        hash = "sha512-OiHjmlNigwmhXEazRkn8KpJqBfHlXd1gT22J18v/hj5W5XMec8EYkdNSS0Pcj7mRHUmKJWeQB0bBx95sDJMQig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.6";
        hash = "sha512-da1Bckkc0nO62ixInAZ822MXqMi7oMqcIo1/PRd/AtmNuL61tHRZB8VEVfT7hHBTM+VpvvZMquWcTg44nwkYdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.6";
        hash = "sha512-6eV83UTMgW9ysKifWY+qvz1KTC077Wxt4DobByn8I+Op5Zk4Cowta5IYrpTAaA2F84I8cKldyqDtcgMyuJ1ciw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-gkgM4PHEEP2doB8VNHiwBTazR/0CaX+fAB/mu2sC/yEDLGvFWF2wPwmVLho7YqEy65XkZUOxvoBdIQpYbxkd9w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.6";
        hash = "sha512-/AneeKhgbNFFnlsbKwsHd7Pcjx8LVch4/sjtbLLYdeHCBEsdFTG4dObQAuaEG+JlcVE3r8yAGpyl/d2HB2nVlQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.6";
        hash = "sha512-nE1uPy5By1aOy3qMujXO5N7/k3KlwhBNU0WB0BUUt7CSK8aRk9OZ+6LpZP0BnwktKy9lV4jlenF6ATimmH9yig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.6";
        hash = "sha512-vhGiijVula3UY5RCzFEFNdoOWLt6Gcm1FZRuE6EHOX5A4bx0poj4it6vkEZTe/p5HmjBiuLte9RD2uwd1aOC0Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-lLsdNjROghJNpR66Twj233udoE8O+ZWnksQEvo1bzQzGw9zUUo4MooUGXZkuoD+FzUDDzdaBmwZVzJE6eEZZLA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.6";
        hash = "sha512-OPg+mErxqN/lfrtwyZ5OpFbcwx2m61G23cZucmaOs2K4ezh2cUzRuFyXs3jwaTgrl+x3uI/ZJoXxGlOIjDsfrQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.6";
        hash = "sha512-prdOLgJLRRGXhqCgxXmWY/bEyqqFOS9crkM/wuguVnrTGO/hU3ARutgJxy4EDTGVVMXbkPj4CK3JFQl1qw+LBQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.6";
        hash = "sha512-8xBtrtU3QgkQJmPb3Cn1qNktfvgWO45GAqQipNUVF01CdWkNQEcYhreUEPiy84tgX1CziyKjWz95MM+/3kDf+w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.6";
        hash = "sha512-mt2dv5Xg0yqAjF8b363gOAWSfyyF+m/Aq9H8hN8P7lDGJ//VZ7m0qHsL74Kj81U/g1Ehkzj7CnQwoUB2oyL2gg==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.6";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.6";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.6/aspnetcore-runtime-9.0.6-linux-arm.tar.gz";
        hash = "sha512-Q18eHRmdi0kBVaTaNSQRN9FxGWsi3RnCM2g9BDHYSOE6QkRWP09DhJl0WfQKdnr3202yP22nIs75oRxzJQqd2Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.6/aspnetcore-runtime-9.0.6-linux-arm64.tar.gz";
        hash = "sha512-inAkvRRCVPQAwHWO/Vw5hU66XX4xh/veLchXzt2QEq6TrO6xaDv2vzkM77pAxQ+VzDKVoajrgxM6jgG5EonfxQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.6/aspnetcore-runtime-9.0.6-linux-x64.tar.gz";
        hash = "sha512-VMEixMYSfOfg8K0EeaEB2xRVSEyeW/+o/cDdctLbAovoaGHzMfLHwcsurumpLnQeTl2lZ3lVM+Rq8n5OSBwEUQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.6/aspnetcore-runtime-9.0.6-linux-musl-arm.tar.gz";
        hash = "sha512-8OfrOheC79iKYMXEW4nyRAaP3Jz7GeD/0LR2Cg9xJfQ/K9AOqvaa1e0rXyt00oR8kW/3lXnHdiin01hl1yuqww==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.6/aspnetcore-runtime-9.0.6-linux-musl-arm64.tar.gz";
        hash = "sha512-xh80kOf2wtQ72Y35WUo4qZE8n2AWiL8GMbviHVUyml9XMfzEwPa/YNtNjpnwtQcAsYhtNC0fiZqN2+nprpbw0A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.6/aspnetcore-runtime-9.0.6-linux-musl-x64.tar.gz";
        hash = "sha512-22cIKmvRLSaN+zk9rBLfMWJo5SQBBm5GrtIa3MVaadMQLVegkwvVsOWiDlq89k1J7KmVGLKskS13mgBH02xFvg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.6/aspnetcore-runtime-9.0.6-osx-arm64.tar.gz";
        hash = "sha512-iTQiffdr2Iq50nb9qKmrmBy4syAgF8TiY6RLwBzor+X1Pai6BGzFpIQaPeD3IXZ9kJZFWXl9A5cUT07RRv9pHg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.6/aspnetcore-runtime-9.0.6-osx-x64.tar.gz";
        hash = "sha512-SaXkIpnyK/0qpBb2aXernIdJ0uBGSSVZFebXugmJ1f0lObX+G6QV4fO106sVKBghoHo1853Rwl20mujK0SQn3w==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.6";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.6/dotnet-runtime-9.0.6-linux-arm.tar.gz";
        hash = "sha512-S1SWWuuF0Ix5WAiFxp1Bt7oP3EeGGPQOOghnPXflmHAiFXso6wRCvgwv9PbmWQaOo9PjlnAQneaCB9O3BroGYw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.6/dotnet-runtime-9.0.6-linux-arm64.tar.gz";
        hash = "sha512-JKtB00vn9nGNepSJ4hmD6FfnNIyRQVfo+gSm/fAQ1DqUKpdXwFnYjIY+/Trq7WeB+SjaNVAhxQuWXo0JFQIeoA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.6/dotnet-runtime-9.0.6-linux-x64.tar.gz";
        hash = "sha512-v+JXt6bcBQU6eE06yWbKf9t6Lv1VOOJ8PqgiqrydOiD0SvRIbfEAIaX2TIkyJMLZR+/QZJLR3zcFVW33ZzcSbw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.6/dotnet-runtime-9.0.6-linux-musl-arm.tar.gz";
        hash = "sha512-p5eaEL+BJPg1ELaNn1A2vZKiHjtiX+M0zJcbec4haL3iZe92yS1fkJ4lOf1EOtfxQmUnBkfJh3Bxf8ZmrRW9ng==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.6/dotnet-runtime-9.0.6-linux-musl-arm64.tar.gz";
        hash = "sha512-R5APJLFh3LJ6agxPrM03KkDgwMXrquFfrqF5CrOiNBT36v8zgUKzRQnAvGHsYylSoHvAutUTfThx/IVTpmz/xQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.6/dotnet-runtime-9.0.6-linux-musl-x64.tar.gz";
        hash = "sha512-cK6S/8TNHPB0Ro2Gcaa5fORN68yvckvLUXr2Vc0uddf5h2OJ49g8pOdF31HpfCsiCbc56inLJN1os02xL1iCfQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.6/dotnet-runtime-9.0.6-osx-arm64.tar.gz";
        hash = "sha512-2nyZR+f4EqWnQxy11effGy+EwifLfEim/69B8saam3NhlIIgcKBQup5RZt51moFfQ+BtmdOF6Xc3BXyls1HUVQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.6/dotnet-runtime-9.0.6-osx-x64.tar.gz";
        hash = "sha512-V2g2mCQAFs3NyNUwLoPRSKgg6ILlIe4YFuByXbd7WvHVIgbnAUmgp2KbsRmo5/eU+OgNO4ZvQxbqm4uoFT1Wbw==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.301";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.301/dotnet-sdk-9.0.301-linux-arm.tar.gz";
        hash = "sha512-qL8t2zWO4se9evwEDRhCb1ySIGys4FcnmPnOaSXJEN0aST7T41MEyahQmyYhpmRVn/RF0wFK4KA5VZx4ygArQQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.301/dotnet-sdk-9.0.301-linux-arm64.tar.gz";
        hash = "sha512-JOIynEDPPkLNHodT2I/ORUvEqau60rAegPMxMKgBEjpTHiJ2c9OBy5cQtxWAXxiP4Ny5gz+30E2rLNk3ofSA7Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.301/dotnet-sdk-9.0.301-linux-x64.tar.gz";
        hash = "sha512-dBWiZIQ9PfeL1X+y8XB06BHgsZOXakW01neNPruSZoVMTgN8PN9LU03nuMZHmbDljc6frG8/PGyssylVVdMdTw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.301/dotnet-sdk-9.0.301-linux-musl-arm.tar.gz";
        hash = "sha512-0B+cAc5u1sukC0OBsSduuAyqZY8f/I/zrkE2nMSq0DFzn94x5jy0J1A/G3EnRwDPu7jVTzpvOsRQVdkmCsrRWg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.301/dotnet-sdk-9.0.301-linux-musl-arm64.tar.gz";
        hash = "sha512-t4Jjj28NFKuRDeOVJ0sWlmTGUrU05HaznSGcVaRtYxTuUdSiykcJvsBFrB6yd/OJspDqxcmmt15QG+QsBxVj9w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.301/dotnet-sdk-9.0.301-linux-musl-x64.tar.gz";
        hash = "sha512-ggXwZUvRciNkVDWH6dLqQ7CpbsmSXDeR8uf0+wT0paNIyiOGCS6hVkpyfgA05Gd11ClJCeuEBTWNYu6DM9Xcjw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.301/dotnet-sdk-9.0.301-osx-arm64.tar.gz";
        hash = "sha512-NvGut6/yqsEXkZ9Xq61yXInay4eaPDuNQbAVdWAs6y1crYBdPG1noP2gIIskd9DVhmjBMyFTku5lv4hYZXHkPA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.301/dotnet-sdk-9.0.301-osx-x64.tar.gz";
        hash = "sha512-W7pAH5tkUMDuUd3DlDx5q5LtkYjh1CCAAf+Xr3my+1HbkkNVSMR/6UP2n6PC6I746UCMeCGlnYQyuEN5d3cGXA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_2xx = buildNetSdk {
    version = "9.0.205";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.205/dotnet-sdk-9.0.205-linux-arm.tar.gz";
        hash = "sha512-kAAySurNNVyxeALQIFeSW2CVuYp7Mb0G1sSecfky1LEhx1mp//d65A5Id+R1tbcMtx/RSc010P9/wxccasCyJA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.205/dotnet-sdk-9.0.205-linux-arm64.tar.gz";
        hash = "sha512-ykyJxPqbPC0JZrEonkoKGpJrN3jZdPTjISSiGRwruZUrgMPTYjXu5zEDEAI/yfR54FuE+0qGdrl+G09zm34aEA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.205/dotnet-sdk-9.0.205-linux-x64.tar.gz";
        hash = "sha512-344tlaYXBRxEpSRHETcwCGjVK1I8xB6PjTGq3paEB65AbVtuR/SE9gO+UsCm5WdYbw+cFv/CWUTzqPQviMPHgQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.205/dotnet-sdk-9.0.205-linux-musl-arm.tar.gz";
        hash = "sha512-2WtVOm0dkME4LIDdpo3UIA+1fMNA84wSdYBlOugmdc2Z7zu2W38VP0OdQjQQJepOARYpRNiNpQuNdXv2qHFs/Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.205/dotnet-sdk-9.0.205-linux-musl-arm64.tar.gz";
        hash = "sha512-l4LgozcmzOAb9oqEMcf+z67rqt4heW7wBBfC+Qch/00554WekejNZur0wGbpAZ98C8rKmESzcBTC6c5BYkuWRg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.205/dotnet-sdk-9.0.205-linux-musl-x64.tar.gz";
        hash = "sha512-zmsD+9lVviKgVRyGFPVsBOyA3iFDdeal3sLMm2xk+NbTDxha2NjO9C0FXPiZqliCF/10xvsNUbE4tqMn+APkkA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.205/dotnet-sdk-9.0.205-osx-arm64.tar.gz";
        hash = "sha512-nHUwIcJqAXjPu096LPS+ZeLvHGzmiRLFk2x8yZKwJg8UpEkAdzFMNjdE9Svpb0MvFpg4ot9LXdAL09P/mFW0oQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.205/dotnet-sdk-9.0.205-osx-x64.tar.gz";
        hash = "sha512-7kuNG2Gwj9z+mM320ctGNUroIDsSVgxz55hkid/NhcXBhusIXuRNavkKCnAsvQxc4dnrTx4NSTPrBD6ztvY7KA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.107/dotnet-sdk-9.0.107-linux-arm.tar.gz";
        hash = "sha512-Netr9KteJY5TUHInT3Cq79H7KV60TTK1tCCG9yFhUjlPsKgqe+Ec2IPB1XQK1/CICfL52/zovADlok10bcZAeQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.107/dotnet-sdk-9.0.107-linux-arm64.tar.gz";
        hash = "sha512-+j6JtbaaUAOOnsKttWoW1QZPxaCAG6jlZ2ouECprsiDU+duEvkm3RCFLOOWDyCmGMyROu09HyGT9fofq+xN2hQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.107/dotnet-sdk-9.0.107-linux-x64.tar.gz";
        hash = "sha512-WI6GA9vlFMIw7bAwfJhSLL1hUKN0JC3GphZ/m+h5MTqKKJUwUoKGV4TqopbI3ujL3gpnntuNy/etqmwfegtiBg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.107/dotnet-sdk-9.0.107-linux-musl-arm.tar.gz";
        hash = "sha512-aGe+uyjP8y4e+/guk4P1mY0QlrCe5exYdRe1LAcAmQS0tLK83lSr3RBXQYGOalCr3DsVWBbsgsYdVZOnzpE71g==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.107/dotnet-sdk-9.0.107-linux-musl-arm64.tar.gz";
        hash = "sha512-jBd0X3G3xZmwm3VGzQ4gm89vz7R91Ie1lDSme+uvVPI6lWlO0wcpAlbeeA8iV9L1oAgCGTHx2kzJkKn1AHzVhg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.107/dotnet-sdk-9.0.107-linux-musl-x64.tar.gz";
        hash = "sha512-JwIJpXfq2TOHOP17WlXmLoPHOpI/n9gfSXcdCtNt8fQaD6ThkkdXFD4V8bQQUioi0VksixaWrehVRH8eaIISdA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.107/dotnet-sdk-9.0.107-osx-arm64.tar.gz";
        hash = "sha512-DBGIKo5yDOekc/y8WQYZKqFO6HR+Gnis1Vz6CwozcZQJPmDVOodSf6Ph59QgqrwzLTq2qwntbrtcxr+hec71cQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.107/dotnet-sdk-9.0.107-osx-x64.tar.gz";
        hash = "sha512-7DDDGmtizw3ONqaIK3E2T+dObWNaQ3sM6auA9Udw4mwAys69YqFGoeJUWRO611yLxTjl1TdO9Np3JdkpLD4p3w==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}

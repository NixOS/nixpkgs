{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.30";
      hash = "sha512-mu+9ePSXljxiuvnd6Q3ECvQ0jrxMV0IFtexHvayrhAt5FH8DGAab0hwYyVFZNwT9eJAVP5Sdy+ffFvDYBl73Kw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.30";
      hash = "sha512-T3ZKhwAGQpUu0LsjkiufWJJFE8vxoU2GsKW04ihRBVINYNpjMJHCHBbu+vrMoKtXsKMxSp3/dZfu01Di5CfMdA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.30";
      hash = "sha512-HUcpDqyYO9doozmeDEDDo65zHjaq+3KjpSVFCpB5AZcLXoNDBOHgwoX4svIXjo7jsYauGaAErcxMba//AT9ANA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.30";
      hash = "sha512-a8zMnBlJht9wIRamJnzKhLtCAztoP1sC+qHh5mg2kuN+eW+ckef5LDSA7wGK6Sw6uYqk/+xyMlnUvf1K8xp7IA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.30";
      hash = "sha512-gDAkLD/bgbMMv4KXonCELGS8UGRUwaOeEoXOUIoVXyc0wxOX/PcUTMQA+95Toa6xdCPrXS4NagfLLV2FAvL4cA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.30";
      hash = "sha512-5buiJ5hJkTOdA1NxdjxEE90ERV2UYbJiB9/L97R2Ok9/WnvqEEU/RtT4yqKA0YqphPmlFhBSN5kff0ccG7tnmg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.30";
      hash = "sha512-TplwAKTVzSxXGC+q+7WvThO6t0DEB/OhoaonNfT4wNu6x6GslgSfaEZK+YMN5z+YGiPmJEDgtXOZHL2mo6cSNA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.30";
      hash = "sha512-q8cwD52JNMGzYXGT3KLES6Aoi77QM8DfgGoDeHeJAhmsXcWxyMb0m4ultGeU0QeG7pO4meD9pr/M7ieUF7Il+w==";
    })
  ];

  hostPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.30";
        hash = "sha512-xhQsjsnzLp8lWRbIOZKGYu1khp0lLdZnon6/Napzs8WqAPVOJZmsEh6ZS43XztuMgZhc+Nlt4R1uNmpdiw6YMw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.30";
        hash = "sha512-giIGc4EddjzwUeVxDF9R3l0e9BqihQcNS3uaESuaRAEwSd/pWLcKIow6dCV+9DklHfgVe2Fj2/uWooY3wHcLtA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.30";
        hash = "sha512-UDjbApreaBYepGJ5DC8WCHa/cggFoZVeWRPDqaQvX1r1LbAmsz7M0vKosfdku8oZjSmyVgfJ6e5PeOaVNDEVVQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.30";
        hash = "sha512-7wEFGLYyv95NbsSKsLSsQhNyF29+5ggm9+p1HmIOrkO6B8JdG99xjPJSzfq/I+WxnhWGDLLXMp3LadXJ5OgYHA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.30";
        hash = "sha512-QFVCM/KDLhQG+5D1/p6rpTrQFGNXT1DZDHvmVGyMor6VHdMFlbPJIF6o0AsjGQuCN+nTm48FAB5xonkRH+8wQw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.30";
        hash = "sha512-+H7w6m1U7gjtBhmpLMliP+615Z53wTwhIP597D4JSLwAkuH3jvDGvI2vHIRYY0zL8QDWMHWAzfI0145RVNJ4MA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.30";
        hash = "sha512-1D+BEXr+0lb4MhokbIx5SCPI0K/CoDnzHy6KVjH8H5/V8r+pTv8ybrNqVpPCjKfVNbVGmJ5xHFB1lmFdWWw9LQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.30";
        hash = "sha512-3mwSU7jK70STUxFPUbj87vyDjCpfTzlG/c10W8EA5w/Q8HU786vFPAq1XxQ9Vi4fwwTh5JjwBOUYaH1eopqULA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.30";
        hash = "sha512-RmnX0AyLA9qTH3HCKIxWL3Iv7qLZkImV1GpD/YRw7nkcGZzZxpOYqR3G7pnvG+uCflTh8KTuSDH+7Kt9rdRTFg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.30";
        hash = "sha512-hdiOTv+9svo02/HXc1CRm9tos+j5PUB9ekBd2hWwWHaj1Y8/idsOqUHDVVKU2eMbFprFfGWLFahQ3dsoZAbwbg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.30";
        hash = "sha512-GEKeIsSa5XzAgp3zyZ1/dQUFDgikZv7Vz3l7311EagUWLk+6B65QTVUkSUcvTCOIat+k6IgNge88i6i1v1iW7A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.30";
        hash = "sha512-LLmCFQq6WcH7flMopwbdL9pW7EX9ojSYj6/ZPUv3+N2N2RUjH+k1HGl2/yeYCXXSvgGfAVuq5CvFZ/M0WTBTmQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.30";
        hash = "sha512-gFFY4/EWhOAd/MfSr6gnvdCQzmHWjfrpWKITm3Jnn1ISbzx3oG+wcyNar5+44IYGUXzhJQIQX4PKYHhjJd4PyQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.30";
        hash = "sha512-2upS9cLbHeTWIWg8iMM3XJmOjaWmOeZCEbtprT7HYxpFjgs/3i2yE0JXDvAO2biyIsJf3tIm/jW+4ErSO7UU2w==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.30";
        hash = "sha512-8IzIbiFbHaoi0XEfrJ/8FreHlDJ16FaB5vM6nOKpLVa+FlXFT09I9DZ8s30k91UeiDSG3G+9CrzmAIsf3rWUDg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.30";
        hash = "sha512-oVcmUZHZVWtB76jHt66NbrGXM7Mjp1Y5EB9sjEnUyWSKZN/B//5KcARcIPDdHjedF+WePebNTydGs/oscsDoMA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.30";
        hash = "sha512-6DchWSXSlXN2R/nG8gA5mD85SvhFKX7ene1H4EHK0HqB089SZ03nk6jyWMrmw9Pzx6e3qjGH4cEhF1qV0XOQfA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.30";
        hash = "sha512-2/iksSg5tvVzLi5hsnBUAYCzCFkXBV4YqJ6GxH9L7OO7YYtyYGJ2e5z39y4jq8aB8ZwjfXjGuNgDFdHDtxF10g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.30";
        hash = "sha512-xMVzuYmNErbSKBSrsrNwI46rE86kVLYWus24FK72Y/YB+Vag8fVdryNZT+v5hdae4lD1hllJkgYY4Ftb2/uPtw==";
      })
    ];
  };

  targetPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.30";
        hash = "sha512-+Oju4F44w45/sfmlDEEUk58DCr/CVaqk5XFKfX5aZiQhDL3i9RYfZMbxa+wiME7//AIUf+8EgidmTdeTPhm3Lg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.30";
        hash = "sha512-CEd/uDGUv4Y57Rs5VeNPhledX/CVo+coZSuwwpeHDm3wPvGgABnmrg9eA1bFjnNK2lbJaUnD/TSpzfCPYaRTXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.30";
        hash = "sha512-XGn6B3+80OpHC4gMsI4R6N0cW7+RpK6go+rF5Q15teMH2UOYomtk/W1ZV+T/dSkc/GGATNgX3RBfLJK7ptG8Kw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-aO0XcxN5oii4vaZ/jn9nqW3CtbeXL9ms4XVYfp2POnq0PjldKhL8wTqewsdZtPSgOhDn4p4f1j0R6Fmcavma2A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-jyLzBZ230ki7I5iQ6gqGFZbaXDg3KxOjIR4Z/38ROaHoNuVv1OQunaoHIsd29Mh2982pguj8wIhajcnUvfPtbA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-DSrMq/icJnCFheFK+YXfDpQZxappfRaXsTi9rrjyJi+3wCgtX3gucBcM4w0qDsPMGn9+BgZM/1n1LJLBP8nY/Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-WX3pDE+eZKY26vI0OOCW/qPeZQyCHTvjtQEcgZCmsRoCEhl7k6IBcHjqH1+mVRNmdvPT4U3bv2eEB1DNKW4jRA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.30";
        hash = "sha512-eLbx5yCvVhlyYeV9TDYRM2tTa37KPeqQw62bgGYdhM3E5FPovkuXB6UtOKhNFoL6u2NnGBBC4sqhts0A2ihOGw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.30";
        hash = "sha512-+1q8/7kOxkAU6oqjqzNAgzDsZzNlPx0+ZjyVxfA07C0yRwkqsFEfiY0Ij9SO24wzwpdmL5axnIPcYKw0pFmtFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.30";
        hash = "sha512-Meh11zUTkViFXPPfav8Ohojm7rNaAv8TslUwO7HSg3+jNG/CSr8xBRir2hWY9AE2ghpJw8ehWG8swxBIla0wPg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.30";
        hash = "sha512-U4SArfVr2vpaLpEuja9yD1I+XS/EYT2Ul+1lsHHsS3FiyPZBhr6bmPcuL+Iq7B2z8lRL9+ETbs3Sv+hVWnf2pA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-JHuCozvpHsy3wrYKgdisSRNMereSSMetBNT6vgR4MrQNEdzGqueKTHWNVAIMCq/UmSdtyP++VapTR6D5VDSNTQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-CB4kn8+XLbed1PKBsZOyWewOCGMC8pZPvMVNAkje/7koc9LBl0HYiaqRPbSFX1+1i96jOn8DEmvSIHKhvWYfug==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-F7hOKhilJ1KwANjRxHRR+/K1uE4jWpOum7O8dht8ouCHCttt4eAAycr6ItDi6UNyAQgt7TlQXlU0d/KpEmHEcQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-wLwlPcOF2aQeb8OMxbPrH9W9ubosGFwQSS88pCDOdKocl2dLvWLVdDnCNzfbH9SUUCXCgim9SlbSt4h9l198uQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.30";
        hash = "sha512-/il9Efv12/m7yZamV8h/2zvZ/3zEtppQkHwWJk8elM/gDsY/M0QthlRH/pEheoNgUl5S1IEjzt1jMTps1U8+hw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.30";
        hash = "sha512-EGbBpn5sIpYS78lxFdVJW69fhWF8VRPczAC2QwHgG8dUkYYKvdRQh3Z3LlbW3YH5Ll/ETxHCjmor8BvV7LYGIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.30";
        hash = "sha512-08uT377n/CG6kt+mpIG9pDsP4wwWK/sVbh1AqS+ib58VBUBt1A+NBa98dy7Ux/CyH5aPAOUWy3qW4MKX5Kzwpw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.30";
        hash = "sha512-PJmkb5Cx3frq83VHon27yqjZ8izkQD26pdt1ERU3ZYjevU0qg3+COFFXPEDqkX7Fj4x3C6Am5NpRjc4B2XpjVA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-7b3w9lJU+wou9gvMInMem/nG2u0qZt7Ng8+YpficnrmNvlUOLzlU2mY2MGBZpI7rqfYfY8EbBrCK1uoNh8Egcw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-6onje4eM84uJ6umweTFgXHzZF1xnLuqQh+SSd27nd3ahCubXiolVl7PLL09p+p9kcGXZ6jOlVLsZaPmIQqe5Sw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-0xhbd5gzyvpkPgGktLJ0Tn86HaIF8deXfXMuAJRZsx79o0Vb0VaK/Yq760Yn6alPKEHmmyszL2GI8qxdYGNB8g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-M1J05V4htGy7SIKdFgCFyDLWIIbDslZWrD3YDSy6Mxnk+YtMn19wDUAUBgGoGAdhacLMR+QFbBaaMUOMTXWXMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.30";
        hash = "sha512-GHXjs00cMOel2SaQPfVxZYiRUWGjzNDjn6u+cFPBCj6/w9KnR9DWnBpRWs6XSKGFZHfGh8QIC70scVG/CnCs9A==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.30";
        hash = "sha512-BDLbjEknMUMRIjz8U7tvsv793ZmSWMhLW8WDbl9Eitp9RE8YGeVbDrWgKUVwxdsomvrHq34LTpUmdpL6a6OMDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.30";
        hash = "sha512-2UB0G2Q+hIdU9Wb8Gmh3W3GLDh2fKkOdU05RyOUinzhOVYLQXe19MSb1im1v8X23ZYOFf2oOrtON+IVgdClavg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.30";
        hash = "sha512-jIPyqc37JbR71HdMV8pXuduuFUPtFdLZSIJp0BRLUBq6ZTjAeQgOMdxJR4WkCmKNElri8FPKN28GGVPz9hGC2g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-xa6h1nOqMEAdOT7IdDRP5+TfkJ8YinW8A8SUkso/DgVcINz5ZjqDE2UwOtgiV6C6EWKF2dmt1Mq7lufranA48Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-dp6opkt7wlqtQ9TYAHA5p5TMoMGpJ1Lvfas0ZrGW95AJ9bph2XqpDumVugJgWcEP2zcjfj02ipjRFRmr65b19Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-2lBDhvABDoYlBVbUYhkNmagiJe3x1OH3pdoHr3meEDnX/R9oe8r6aej3QWFEIEiDiMQjwG6DdPxrcYTkDQds5g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-RxVrKJOqgf6BFEMp1n4u7Q1Uydve7LQeZThjQ3Hg+Rl+r/FLnh1X5rVm62HKvmRTTfJe2k+wl1iB7rI7vO/cdQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.30";
        hash = "sha512-o0DMk/pWpGlrM8aLOZ/Dk7qCFJDaif2E46E4BWMamZJvuXfYevYjcQF/7Pwy5MLHjahspXPqyryQOJnrHrxoow==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.30";
        hash = "sha512-h2C3ao+FGsfuUbgBHIX30QEuacIhmBNTkaKD2bq1sp5bozntgtrX4gA6EnLq5E9wUwTP/qbRx3eqw7GqzbfHZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.30";
        hash = "sha512-F1HebDU5rCOtPWDJYYTnGPZ/dt3juOV2Jht6Vy9LTESf+FrSkxej67QKi27h15MKcmAjE14gKXTmgehqYTRrtA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-cotOnjUca2jQ6ZGLT8utqzd/HK7i78vL5z7vA7922wjhc7cRsWISXdNJGp+ToctYMvzeLXJu4p0MnU155+z1pw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-7U4gZ8co2883pXQ71j+gddnqVS7VY/b8D6a7rDPgbtWaY7ZAcUH3aJZnjoYg0QwJ6H3rMD0Q9eB5PdhyMZO8yg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-2NlIW94p8Un4XK91LZsKI8rXqXozwT6jrZE4jmyAwWohLwOTWG0sKYvDuIluyxuSHFpaW1B+0goTcp8NPOGV5g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-+k1JsW/QHvb18liWsjaoTODYOOdkBBHuouuniquSIgQatNh2MknuU/t/rkDYBICYIdbmSeYegGkXxwP1gbnc3A==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.30";
        hash = "sha512-y330paAjGm7Ychem7yf4P4lIp9qrRCtuZbSO+4i3mY/CXJRpE+sURlPrRGEzJ7Q94Hbtn5MJq/Rlzeyom7xxRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.30";
        hash = "sha512-ybOlFD0mlgBcu3PK+GL44xOEBGTLIc4uCq4mgqpsT2YD2LnXWFac41L8Obh6+T/NdnZN85w0LVg+cbMId2C+Fw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.30";
        hash = "sha512-GUCdFGd2H9HjiRiCs+MRy3Qzu1cycCpOh1UVDTdsUF6VHgttkpiCrJ3G6P7/mRVLv3pphrtWchm4mKTcvazb8g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-J/GJxdBp+L06OOP7OagQ/YxTcvpjm2zqOnNcNiynmJmcb7Uvybi8Hmnebnd+BER2q8wwXI779qW8qUaH93l44Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-ywW7SP9MvjVvYg3lpKffBMVi30CvKF/+oI1lHAmiUnVSxCHiip+/hPWUgXhAj5zLZVzY+kJUJCTaGhq23hSqaA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-Q6OZ99nkjG2uiBDEcBfAcQwtSP53p3+kLJOgkg9WMgS7QZ9o57fx+/CMaIKtrTpLoyebv3YLdIUmUlhHMccxAQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-7+J/WVNTHXK7pmBZZ/k5CgiZ3DeXVmFnVV/Ytdbn0vBRqs9WMBoJsnbDdY04p734X4VEU76gISoWiNoeW7tuqg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.30";
        hash = "sha512-ZqnEzTafVg7MCWytel0mYPGZJKaOYE8fk14s1vLWNR+g9nhP09Zm0IcgNT5FkuPyy/uvlC28Tt4FUljOnRjl/A==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.30";
        hash = "sha512-pM6sXh7YZyRmcCMg3EW+q4CIBowX6KR9u/GgzF5Md2Hghgv/EKuev7CFuwkLb10tP9O0shD4HT+7vCyJ6ahdeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.30";
        hash = "sha512-3IpAltb5wLAjz/ju6cDL4MbX7NetnOUlWEBdCld7FZzZIctDWmkscy7L38IdsW7yDYfjbruaESTBnXiRiWXBoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.30";
        hash = "sha512-pIJ+u67M51EmqXHTNQMNuRPKmp1eCwYebj+g36Tho7WWXYylvzwxAvTIOh4kYcuEj877DugspMEJWY+P9jJe4g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-qUf5ukmmDS3HDkRuNkl5I2R7yXl2IuoMzrB/RAQmLbZ9XVQiy+Yq82IHgt94wc66RIYx8d47kSbJxDrNJTCGKQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-5FzkVc4TArGsCUJ9zWcibp9wTuRQifBPay/5mfDNn30YiSJ26Rl/1yUIizvVsYmwjgQp2Qba+Fmbzk/lQK+AeA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-ihNBTlVaf2eZ/CqHvM0ZnCqBp2ZPqNVEEnY/ACjRUFnKQ6U3raubRnMnN6oiUfkGj4nMzQr3wSlgtdlCaj67/g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-/LPXlvBb0Wg9tdCR7kHoS4PQZUKbAM/VrVRJMzoFO1JiHxcBUBQ32SRwhn/uNulTxL9myhSfYuuRi7Zso/2HmA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.30";
        hash = "sha512-fuYm5UU1qP6jpnCCk3w3KOvZ7pRPMv7uo0xlUSulddU+j5IYCje3yAhuKOJRk9DTT8m1Gb/yJ6u/ZotUJU6DtQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.30";
        hash = "sha512-Nq/xFyzEctcwBcRTFlllBZH3SwNn/HAmQFog+eyZjLJCKj9+Pu13v9wrzshb8Ijy4n/L8azFojct+FFKHWXqOA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.30";
        hash = "sha512-gv86fNAF3t8DSkjEeejR+o1C4MNEI+4AH8oPkC4AbO5HKPzGXZWTAFB36h7f7zPJxhhlwCTqO5IbbidxWeiszw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.30";
        hash = "sha512-iJ02Moq4r2AsNeO+Df7LgyTpUW4ZZdKR+JdaqhagG9EXJdxgY+ybjrlbxYje03ME3dM047/piDvyCsWqhF+70Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-FfwWHsL5B/6joLnEFQ71aInB8+zidWKvA5lbJpUW2mwcrIuPBYxYfFNoid3GE6p/mv1+JRwH2BNWQ0YrpLaLeQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-QaHE2JSx9OycyrKV3axueyUZE6AglaoIfw6BFPuYBg9/cY5pEJ0xHnusII80wJU9Aa3W3l4Cr9xPOWISgwtGzg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-31lqAja6ZiPI47FahFGqFZtrpSct8paV3s8yYSu2Vzy3gnORoAXtmK12WaLTH+v1aGxtvuAl05bNn02DP6ozZA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-AvgBADFn2lPvTMCJmWBqtn2IzPBLo4mmdXrTfWbX0CW3h5sPjl85ZpUMnyOwa4hrY4TXJqMRelAvpmp0raA0Jg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.30";
        hash = "sha512-3cuqwrHAEsrYuV7TdriSJfIAx/MRa33ag8FLqkVewAS4qg53UUKfOL1WK0rZba1WrI+FIMlXx7N3FdCtJCbKcw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.30";
        hash = "sha512-JGVPUdnznY8ZXffje8XY7poprpi62Zmuln1GO3hIwpNtomX6rl0sHj69bhO+PoOSYhHsw34dpwVtarAW/xRmKw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.30";
        hash = "sha512-JQ8Ar8woQZS/ybl7C/e1e9wgDN2AYv6B73N8qtiMzywj8q6/jE+lzGw/A+XxShEIX8BZ11+8zKWaRoN5B7Auaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.30";
        hash = "sha512-lRWMJCenC49iG3fuBRpXkkaSZ2oJql4C7OETw1tbW/zaqsTW3/wqYPQoXGKD01Qsn8hpAYrLxVMwj/gRUXngIg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-rovxZlVDDnYEF+NqcmLaCWveRjDFf/cMWW5vxW87T5S1rbCsLBprIQcox7zljDoS1P3Fw9kkVHlISDCQ4SjBag==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-lFZTuK7/sQw9pFKPtNVD7C+jAzjhsAnIyO1ncKPyAR6Uo2SR+n5l/zbMj8J57wJiZCAWJv+DSXJD/e2SFNKAKw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-rVaR+ZeBBaiHMU2z6ky175uTmwdpOKUJ4NkGd9puCb2IBhNd/BZ0VzMrFyC1rJ68JstoLt2/nNR8VXvfoaBfhQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-vSB+pLZYNEEwXTeNrzvRQgYE9KL/saxirPCWb4xJOUoYngCAc1aeM0poNFWOC+jB6XuHJM4BXUKNXcDdh+NMAw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.30";
        hash = "sha512-lC0XlOWsbeFLRPYYIQym85TR+pv5r3GBbGNtr8tu/af0CEGt+D75UQJdoNjyqdZNLAIUhnoF3TW4xbtZ7g7tPQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.30";
        hash = "sha512-MW1qT0e+sE2lUQ2+EwU+cX+n7JGlFJpP8i8vnr+j/skvUcfqkTT8ggZ6RzBzSXLUjWXq5TrsYEzCEd2/YgQmxA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.30";
        hash = "sha512-7oiBHBIHoEFHkA0jHGrhg9CJ0EegAG5RJMazYl3EEYN7g0b0d7BLzGNCVqtNl+stACQxjQuHsYkmsS8SFABJVg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-rMX0IGPhVa+wz7Ns7VXcXy8WPQvQktVHipa4gI7DJDfau7mmlFs4XW4e7gX7j+3r6IfjQUynMT6K488avMfIlg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-RVLeUw5K2S/yix8e3hjuFcfL+RunsyT0xuXlp6XeqehoIQ+c5gUKC2O8F40Y7pDejG5z2ayKpnS1LxXOZojbwg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-sDLhTjFOtrTglLZ/Fp322SKdt6UHgs2cEJQHmPnb8WeCXjZtUbBor+qKibn/KlDRUt9mvJ5SQAQKn9SAX+AFOg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-VyOuk/yLYYuTn93TY2rmZny0/F0DP3h8uEJuyJXXsV5N2LWIpW16AeF9ndnJOpnzI8pYJYZYMDUadhL8YSe0Zg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.30";
        hash = "sha512-onP1XJKHsBRF5/9XN8T8DdYTE2023+2pY4vl5bjEiZx6TYUyi40y15vbHQJi4ZM208V+YBIkO2Imal4eGi0akA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.30";
        hash = "sha512-glQo0sPBrFibZh9WoKYl+6DtbkdfIeR96vIhh44GtA/O1t/5dTW7sD7WHGWdxBncvzYRiEZnyDQEoRu+p4Yqqw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.30";
        hash = "sha512-8qoX8FVrnaWJ3dJevWxmCGfYwo0lA6fdbw2GN7BhK8nEbTXVWQGVVvLX+L5EtfyPxCpE/5qxgvl8I5CjXUGjAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.30";
        hash = "sha512-avTMLEXGzB47snI6WYxePG58EqP7l9hlbrdqw1EkCfNVUzN7L3jFes5kIoXLKupcEFdIxk1SrDOo/AlJzehuQA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.30";
        hash = "sha512-ezPDuJjvUJgeNqHblpz0DPvbXi58/Yhql7ZZGzeh+T6U1ImtzMcWjpZkT4MroLCQBYYIeizaV6BGBIfaRkIgHw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.30";
        hash = "sha512-UblXw7/hFf3XSh3f096x7gTplPvan9cbLGGP6kkTCPboNJbmYXSk3fkHeOFU4OrhbyitBhhN8b5UGuOWryjW7w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.30";
        hash = "sha512-ilD9n2jZfEdTfA/kvC1j5d6C7E/SROaEnGikOIZDgtiTKIjg/uk1tOBonNt1zh/hdbEoACvZInwrR+BVdDKJAQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.30";
        hash = "sha512-t6W6B4zEWQthvPC80JYRqAN0sgoIq8g6WDwOL3vy0U5MAK1RkPDW0kQHHzx3Kjn6nCYFH35tndLaOfr54jIvqg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.30";
        hash = "sha512-Hh1WkS6Lb29Bo1ZDlJy2Kp90CMOjDRmlSg6777OUn8aozXjB9Ae4MVazzqd+0c2YmzUcVZlNXzEe5/LiO+XtYg==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.30";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.30";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/8.0.130/dotnet-sdk-8.0.130-linux-riscv64.tar.gz";
        hash = "sha512-Wy9bhKmSiRZNUqxx0+i1hqWOhsDNIOIhwKQYXouDG5LnjrPpd2f236h3lqGWX9a3rZUHTxzAZVEOXvJh7iEAEQ==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-linux-arm.tar.gz";
        hash = "sha512-1n1IhT7KriFvuwKIE9cAMBMAR+QkWB1Fi17pg7rUsQsClh+ErNhOnsMIP5N7IsjY2LsCIjfEV+xru3TtYJDwpg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-linux-arm64.tar.gz";
        hash = "sha512-J52KuEthAsKfyWtZgIBegMZ5ojSr2+gEeqn1lUsmDdtwtK4Hk+LDeTNdIN+qbIa998i9fUQsjr48AtdbELyKTw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-linux-x64.tar.gz";
        hash = "sha512-QV95Qg6fxGVGfMqyN/GLYJcQpxXr5DzTwFxpr5ddR0/dy+N+uDEWRHLeYHOYdCFsRR67+18fsEC0HpDkHcdyBg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-linux-musl-arm.tar.gz";
        hash = "sha512-SwObQIKZHg4kkQoBSEfaDuM1Mse962GusVSbJLjzckbJISTIwJiWlz0J00a93wGvDGB4SB7/8mpuGNKHJ89QzA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-linux-musl-arm64.tar.gz";
        hash = "sha512-4eZcXAxlEI9CagrwtIGxeK/RZeFbptwLmsevy8LE0EZGxxoyFqgLgV9CWhgv0WBR2mwAgcf0p6/G046R7eLmLA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-linux-musl-x64.tar.gz";
        hash = "sha512-z9gcar4Ii3IvS3XP/4ij/fFh6/bt0ApFDeMEXHAUvHAtLvm/E17NTeatI3dqeVeoQrjLqo7mSosCOknl2b+mPQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-osx-arm64.tar.gz";
        hash = "sha512-I8gV30XCIdVZvvbtPBrqdDktFMZaAuxtXDn4PrKGpqwMddyXoqry+q6qeEheXKZPVUNQ5PvzM0oUlNLfGqxpOQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-osx-x64.tar.gz";
        hash = "sha512-/iKmWM497LZ3Q5xg8nIfrdzROcMKZfEJ59lx0LOxo/RvPtMVZRdCgDLlrH2lVYQY8x27n4DWMF+j23mhTox3ug==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.30";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/8.0.130/dotnet-sdk-8.0.130-linux-riscv64.tar.gz";
        hash = "sha512-Wy9bhKmSiRZNUqxx0+i1hqWOhsDNIOIhwKQYXouDG5LnjrPpd2f236h3lqGWX9a3rZUHTxzAZVEOXvJh7iEAEQ==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-linux-arm.tar.gz";
        hash = "sha512-pDlq9mts7ub5U1TxNRlGMJHeR0kzBQcUYJhM4Jv7sa6+x5B7LqAfHbEiXk8ZRIHD0X3QXxc1wCgbnRd4spVChQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-linux-arm64.tar.gz";
        hash = "sha512-uQD7WCLkSv/BENBrnF7Tcu0BSF8wexkAvOoL0am8FmoQmjWrdBMnZo2Dov6disCpShKpT0GIvS+OHK30BGl6oQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-linux-x64.tar.gz";
        hash = "sha512-ZNkhp6ecMsWj9F9Uc+i1bUEYDE6kEgS/Dv0fG5JJwuUJ7iGTQWFxOPo0/3mn9sqFI8SnOimltmFt3qLkMgTWLA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-linux-musl-arm.tar.gz";
        hash = "sha512-j+Gl70JvMWHhm+hcJcDnDhDmH2d7bczutKOAa4h0dlGc9l27XG5/C8enX64InwbCoA1OmrMbDbPgPT8s1wLDYw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-linux-musl-arm64.tar.gz";
        hash = "sha512-ZBuqE2r4iXoWq8eCuWI4PaFmJhGA2K1SzlezgKvOuhd5Bxx5XvG4uarykY3lPudrPp6SJnYZGcbwjQ+YGCewPA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-linux-musl-x64.tar.gz";
        hash = "sha512-JrgrZBKO7c8RCFAz5kfL3mrSLPE8RhEAbyjHqJa8HhFaFJsAbroHeLx1lfe3WblOl00c2fxbSpCsHvUDxKd6Xw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-osx-arm64.tar.gz";
        hash = "sha512-PT4d5PeVaa0io1m1qTW+m7romdD0Nb4xXmNga6pvbnxAnrbzZ77mSkK+1RnUpZ2XhoF2yVJqv6S9EcpMofkOPg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-osx-x64.tar.gz";
        hash = "sha512-yLxbzP3jrXx8MBdptjkqw+jievkN7KxYHer9ORg9Gq2oVwGMXizzzibhlJ8OWFZSLQURLVAEDsAZUb3vzBlhlw==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.424";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.424/dotnet-sdk-8.0.424-linux-arm.tar.gz";
        hash = "sha512-x7F9NMrKOZ2oQxvJbrdpc7R7xl7DJk4Y26bxGPI7dx+33grGnM/WHxL7NjCQr1RWbIBxQcCRAF4oiELiusBxzg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.424/dotnet-sdk-8.0.424-linux-arm64.tar.gz";
        hash = "sha512-uxm2d5rZPRRgVVg9ZE7yabtCUB9sf971HhQCbN6dX9cm03DeCYqNhQSGf7JL/LWriMwivsgSRhrt4zTeGqz3tg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.424/dotnet-sdk-8.0.424-linux-x64.tar.gz";
        hash = "sha512-ZQP9n0ZNXjpPQ6iB0rdK/GosRs7adNAn8VZbcjn0s+yISFfAPA3NSetS84TVrh+lqvE18KaqvFUYEDrO7WQ8dA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.424/dotnet-sdk-8.0.424-linux-musl-arm.tar.gz";
        hash = "sha512-X+bM1kQafu2zgoydGOsQTwfaSWQNSe8lSxkgTXwIH27t0zWkf1sHpe2HyBdUyOnggjlCl+Ul+s3HNOQoYqKvSg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.424/dotnet-sdk-8.0.424-linux-musl-arm64.tar.gz";
        hash = "sha512-y+gafjhDxf2rEG6G0siT1MwOJ+I+pkqz0j1sJlBfE/idvr17o07//Q+l9LkUlaz/HgFhctGtA9GBPORvee1N2A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.424/dotnet-sdk-8.0.424-linux-musl-x64.tar.gz";
        hash = "sha512-N3RYgfwjKHdGxPZ2Ggv94onZSkr+QZetIxHncu92KcCN2ctPawN2VHZGm6lRrpjNY8Hq3RdE3zzoL6QI5n/Fcg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.424/dotnet-sdk-8.0.424-osx-arm64.tar.gz";
        hash = "sha512-l1toaixqXWKyDZXQSiMzJWcPOKzCq1gV1lEm8FM4eD61mIsW9QTJ3lFqY6VQvO8MBh/CD9JfEozFtGvpVwZZmQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.424/dotnet-sdk-8.0.424-osx-x64.tar.gz";
        hash = "sha512-qzkQQDb1ZlmwMcfJRJST1ZqecvTwUUadFO6kMWog6FYg1I/IqZ9ZDpinakFQVG5080GX6/SIbmKQH9AopGkOWA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.130";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/8.0.130/dotnet-sdk-8.0.130-linux-riscv64.tar.gz";
        hash = "sha512-Wy9bhKmSiRZNUqxx0+i1hqWOhsDNIOIhwKQYXouDG5LnjrPpd2f236h3lqGWX9a3rZUHTxzAZVEOXvJh7iEAEQ==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-linux-arm.tar.gz";
        hash = "sha512-P3Bz0urrJh025M+03V9DpGJuw17CLci5zHrE1ukQ6l6gsKfJxnG3/v0EARDnURUlzHt+VG8Kd25NTeek8WDQkw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-linux-arm64.tar.gz";
        hash = "sha512-KhB1RUVC2tHn8UxrptTLnA2BjMMvhZyFUJyBMDqJa7ihf+c8sIzPqWxTyEzP079kceKul0StOaOBJj5ALt016Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-linux-x64.tar.gz";
        hash = "sha512-Tz7XARqST76dCTyrCH3v9e2bGfwN4CIhF/2nwTNGBcMYGLAf+9RFtp5Z8pT7TTOD/QD9GXAecUKst7yIubTsqw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-linux-musl-arm.tar.gz";
        hash = "sha512-5vdXBKk2DVZLRTN67hRmDLZu2RtyhK/HrV4nI58dBizlark6AOJKDX2gxZD/wkndxsdmEC0HiRglTQOJutrRKA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-linux-musl-arm64.tar.gz";
        hash = "sha512-DI+w/ne/Z3+Z8BMVO8+8WwHGi92lJV8KLOiBvzyIfTnHyM5XJ73H0B1xS1bI9y9Hq/ThHzI7bXXgQbA8LUmo/g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-linux-musl-x64.tar.gz";
        hash = "sha512-ZFOyAmuUOFirU5ZGuBJF4817iUlAhWyaSOpFl4sK6lVY2YaSEKdVzuz0m14/cDjT5rHTOJJfeG0azm6rMHtJpA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-osx-arm64.tar.gz";
        hash = "sha512-/20lYxNbdvTKeHNSozxVC9P5A/R+dqTQxfGHErv2GwQMui+lHBpVDt6++JvBZdWfP7MBJPd2s9Wjt1LPpY5j+A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-osx-x64.tar.gz";
        hash = "sha512-cd5MtwFiQEB0691VkBIOBrGhXjHYGVxNzi/pAmfLzHJ4thtG6uAecG8F2UxRIMNhtEQ0sayS7t8I58Onp/z7LQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}

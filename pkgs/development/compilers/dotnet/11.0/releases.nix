{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0-preview.3.26207.106";
      hash = "sha512-v9ejIc1iBCwhl8FAuZY/qCVWJBrgWOr6MfLSsYodTFTx2V/X6LKU1Fe24LegPnbpoXqIJmLsBIQrO4KoIxuvSw==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-preview.3.26207.106";
      hash = "sha512-ecGx9UpGsZkAlNFoZjtDXwuAuh6wCPNz55MLUhmLINpAKyrtIxX5mq6BQETx/P97IeJaEWSWX45OF4+d/YMj2A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-preview.3.26207.106";
      hash = "sha512-vm5WP67IC1Np4BKm9Ru+LbzSRhA1bkYy8zrZgvp/UwH3j6ZYrKNqjRt0wO36gNe6h4wWhonU5815ML3pWApN5Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-preview.3.26207.106";
      hash = "sha512-unbntVG3e4LZW6HNkL85AapaCPrvCLdKn7AegdVkIHL+DRaN4uL+Rzu6UyloIx771dnUHqve0E/no8mJ3WHc5A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-preview.3.26207.106";
      hash = "sha512-H1D3C+gp/xw1yY4K2dSR2r9KPaRYv5QJ2AThbZVcIhkLEYaXMnw288Qzxp+PnLWUyeUXloTiNpKxZKd5XqDohA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.3.26207.106";
      hash = "sha512-R0oOS+lwsTaHWnnvA4dBR3tW0DYczn+UZJzZ8VIrnv0NAvfsVtWmFZTW1RGm+5EMl9WcESvbwTdxtN457OfINA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-qYL5UAYuutTQcgU4mCHmpOrs2kBtNFvcW6TVuLtCbxyiF3bBBF8CEAIdXy60N6pUI3IbCMkXNvXd6g5AeIKwcg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-vXKuBO0i9nUi9uZbtEl3henxyik4SsWJwjTV5Qwz3W0OcE60wc7vAGiS5mpp/ri8imRoOOwqHv7LOWMwVquCLA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-G6RhMVU6MAMvYAy9Eoq5d+bOQ4aNFslQTit7h3ejwyBumR8jJ4La+ck2CVunYhzWq5W0nzYzRKDr9VXIRKZW7w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-6Qh5ssxzcqrDlgI8EDs50xdkMSk8QRNCvGzF4pf2PJKrDRwf/JWJZuVhzD9VnUQYj4FT7k2K5E++zTWfmeqjXg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-tqmapfWDTNsoVsZD/qFjt9YTnurI2Yk+MRN1O9Imzm50H2xLbcZ+REeozRaetoTJkNjjOqnlnQsBgeFuRLQzpQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-ufweW8RLeV5oBvsOVIYhhq1fgpf3UHoOj+FYLN/q5MCw1yS7RKQpilpk09Gwqi1yZOPX/0p2DV/RKnIlrtS/Wg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-K2IH948OGXOKv3gyUAUQWEES1iyu6Mkbxywl26nU+2QH44A+XAKECcRhXnENQz0K7PX1xmSNaMPfJqZPrqRvPw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-kzqFLg9HiUZYTztg9s8wrOuaL28zcwR4n544ym3RgQZBN8co5irQmxfGYYycNLe90tnZMd33dzTHzCS4w+7Jyg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-92+59M17m2iYairYoxMSlGntU9SsyUIO3OFP6rlMwa7m/CKL0rQ5iolCz4m4WbBAuVtKARhe9bWUZl3FyzJI8w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-JwTIT49618ShygrCZlFxawfdroMPv5tGrtnml/MFw6570F71Xp9hTtWj4HcGgnSAs0q5FWtaZvvoGxfh0PAniA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-6Wx7R8lAJH9+STlTmhvkeyOPTHwtL88boOFzXBWykV0v0yypzdFvdOfjAvf86zSW5mSQMY147yATjckSE3q2gg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-45PH1vwghcp6ffZ6sV7PPsJw6AHWqC4wEwydh2cxwiikY+OmWAFeSpAAPAjY22zJ7Xo0F1s4+AO66y4CtrUaOw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-k39ojqAMM5zpLrrM70KhDN5dVMkPuaaNDEQqxD/5BIzx8sXH5q3m9wyxhPAjEqE6gNESSuMNUroxLz7U5e+4AQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-RVOrXi8vm+AB/6Ma3kO3cOTpMxg/B6td8edIeiu96XyrOB43HhoNc4KLJYt3//2Zj92sBip3QZhOB66+XvWMbw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-C7DG8JmkW9Sg4eCCRHRNbvKtjLC/gqG87Rc5/98l/ND1lQUt/zpe3i4W7KkRaF27B9J4Gq/Kp8v42lopE0Kc1A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-8NpmV5Mi9uazvpb5dgKMDaP4h51oaXQm2/zJ9AQkOLCaHTuIC0QU5aNRv4Zv12yhJ+1tQVXtcr7PEGoa6ftdiw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-/Jg3oEfmXEY4rRR8EGz5Xu/mU5SZnGzqJe0wPoDCgJbtf3STHRTtBZkB8+DdYss25dkq+yMzCqJDg79beJ3atw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-+WSonFTv7KjUG/lpJ8yojhJa0vh7Gi9mpg10WXZeQ/olGKe+IJBf45DpUWKQG3XiehUg5ZbQSKW1Mph13EuLVw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-+Z4QLOIOxxWnel5s9bKr6xzITVVrLOnmCxq19haSZj8gF5VvtuSvoxysD9mj6JWfGLWrYCMWuw/TLtk1ufVmRQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-9xhdqwdodcbW86pgg1bue/1D+OMkoku+HIaOs+Y2HeEWWUkuvGaVknt1ZPURhNN6LoLGioshBwiLX0FZsBm7tg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-QzRRGW+09aDpSSFtPeDVkSvvZHO8wRV2uDvfwGBXFwAvS7T0srl/iF6yqlGGLm/O00YLexvUbvbo21/I/RvSbg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-tzRhQBoSzqbQvL82tpdy3AOr+szIxCFSVJd8/8MeauJ0x+Ta4KvqG2XAjB2vaT+YZSo8Wr4OZy5eV9dyZ15IIQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-S7t/ntT28m9KTteqe5974dSXa9UgZL5FzZnhLa6+HNvEwJi3I026JExPHNsPKMDanXKd4jspZ1EcMFp93sCZ+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-fTn7AT8ohQMd7yUvy/LZlGCrGr+wdZlWzn80UYAVnVmwX0CkXNIJ2FivqyTBFVuIJb6H3iIVYsk9pTebmxAb6Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-cqn+9UZlNhkzywCde0Qnn64+DvrneOw63CGt2l49gIlPpROoy3XZ4NxpsSAq2coyeFYzYCc4Yt5zym0Sw4MTfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-8dRbxg1l7NmevWCg21XjkBaA5iUmwInnKzOS2CUO/SKDRYpncrZt0vPcVDg61KiQJ+jzixrxuEoYm5UadQwIWA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-FMwUBAikT2x1waTYFb5BmDqM6l+5u3DUkcLcGUeQRXUlp49llUjDPJ7lNgi2RbWoDKlNGk1uaMs4+TfDzCsdJA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-rztxFHm0e6ZyTVut5NOIDypktJuJmgxi9pXg3FZLCPdQpxyoRGzZAC09jAopN53n8bxfyGt6Fq7uYWlPiSx4GQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-GOfCqW7YBw2quGeJX9iMT2N/rgZqH5iE46DTlie3KCMLYhlu8ZbD4Vx1NAuIc6RG31cyvcwTbo8oXt4OUOqCfg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-uy0CwGFb9UBJyud3t9DTNTohncZKKxaL0adsA+/sQ1lRt88qv6fZlOfWj3zH+s9H8RlreDQNmnWVp0R7Ooqb1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-3P4sEcwTUuEigYuuqjNhEaUrmuPHlivRosmDqi8FcyXUq+IydBBKScEnaYcyA+84paS7088o4hany+tRNb/ThQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-1aPEbl8CyJK+JaSKp5aKGXTptfU+4MqLN1cKeXehibb+ujjrOnsaaDbS2z24l8ygCSSbgiWNtc0AtWoKzGl5Tw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-b1vqxy7kPh3D3nUatLiYFptmTFwokSJp+sqFB1FqNeh6WglDsriuescHjRdLaTY5cpHzPjo04BE4/X7aRARf4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-fgKQBYlDxpda86MWKOQg93vdwLooITudikNPBMX/638+QTG7kisG7XoKV1PQ5XRTumuSfPiXwYrPJ8XJPqFfbw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-Meqyq0cWoi3shkYQ/2zMp7/E+OOxS5xh7RFFUOufOj7RcndaDH4R39fNehsEycG+o7VueXQjTDHX5cuQKo9cwA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-pnwWF6BmcbhLGZ3r9AciEZPHRRqeYA42LQgd6RiEdIAX850b0bPoR/K2L9Z9Cmr5eU++WvFm1h6xDSLyps13pw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-529Vmw1f44/cSFtaSgglHfpk9GsgfMx67M2Pd9V4lp07UohhGLnIbWi93tesF8f3f6DVa83HDHZVcoi+tcrqPw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-v/Vou2NCp4TaHuqcmyHwD6tbS9ZeEB8UNpOGiNashSl+oe30PXELQZAPo0jUyhEEFpQXlPv9mLKw3GFwOeZVVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-UCaLlw6ZA2+CvbTvpT0M0FVHbOiuetvKknr0po864jG5PrlO2rHT3WzmlN4a98Qf9yl2Gdc5LtuwmDVwcfT9ug==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-HSXS98H8g4asFOGfCIQ9l1v0jMvyn/tVFfMXu+WSkZbImUeIFefdwrwx8yfGDFUwD0HdDyTFZ9Yn5+R/xc1Jfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-9kjJVJV9nq3uPmGfLhduXZzd7s7mgG2j+p+/Iy6vUeRz9N1Q9S7tcukj/2M+IVEuR2Hkah+9dbZVhNmexKr9eg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-OgsUPS0XMjsEaQCE//fEBx6Z2nUl/jzXxD/fUmqM2tzxp7cuFadbMjYhKSiaHJBDgiWv44mJNZv1mZc1z+fjAw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-FTc3titT6ZCr0H0JcgoGWzWB+xRwdXWkOV+pwNo+K78zIXQFJWCQQfo6LAUfLvDZlqxozxkaM+hDrrQpISALhA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-lfR+ifWtlhM4/SIMEa8bLCyCYAg7vU+fARkRcO7/UgfLhMeSI3XQvwDEL3UxCmaFMQjHx+V8z93fA2wCD51rxg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-mxKpkfZzMEG5FinMt16xeCtrP9fIgpuUrhabyZIezcllck70tCnJ+no5RMOiGegoa0RS8GlFfktgwbUNGda7gQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-L9Zqe07OOR5e5swhW80GVOVHVOazQzAFMUsQ0OvT1ROoV8GwWxopeLxaduvRIJ8mrrwojr1Qh9R+Wm/L9DNYBQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-8Lf+zLPZA7fdu9qZq58Avr+5Bpwhk4xpK0/IIH0LqXMmuq8yuNlKGdTmzC28kE0aQ28eBUyw+vR3kaUxf+zEmA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-z2V+omJ4hstb53weBUAQSR927a2xDBTDtzba1vZvMLSOciWju19guP17SS9dFd9chaImfskG2+lb11l9guRs0g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-ZRzzqGejfhzYjJtelFev47nTRlByX23VkSJEMEEbnjm/GIkfAIaoii7zjFzye3Th61z3RODsLNcSIhz3v4ma/g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-hBWzZdGL4XCxxsJ+mL9il/UZeCe1F/p8ifC46u4GpW/r+13LWdxm9DA6Gd9A/gX5IfltOE1CxWZoG8EXP1J5ug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-COCbrVk2ugW1L+vrn3GEkvbL7mR7yTjQokOfaIuhf07SliM4bt8c4WIL31akDAIKoUPoEiiXcJOLK4iFYdIaDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-3UNG8Dpxb3efcwjFkkA4Nll4tYuEsuSG0EV59yVBMWmWDQlqaYvtDHENNCsqpUWtCcRP7ovre5jVQMi0mC9+JQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-HjhumZ+SKvzN9TBRyJ+wivZGSz3OEYpQ0D+z99Kir00FJD7Lu+fIzkzN71xipPG0PNeo0PdI/GwPowdHl5qsfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-31FlRjnxww15d9LbWL9ajqZFHrNZheOGkyt0V0QyzyJeTm/MIKY5p9A1QPbS/mFHYAuP4eilAM5mj5seZGUYFQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-yGn04OHjVBBHhbutZdPGYjWIKHV7ezRBKheeeXB0739reyAGH2H0RbGvTN8jgjiUznUku/3os7h5xvq0sxb5Xw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-oKlkgoPWbrT7ReENkaZfN1PWj7NkDhU1Q9LHXa1O1fQqNZEeqkQ2hidjOlZptV/sE5BhEcAeCjjIl6vzIeLURg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-6X+HPPT/dFsr5a98MsB98F2jrN4aGOAHCbGWyvaY7uyGJpoODgozPd0BiRHZqi6fHRn/ykEijsoBss9VDqYIfA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-a4S3oDY93J73dNmHnEwMl1AcYzlGFvNIJVN+oSzxGhSk4BNUnzY6Dk9tdNr3jDX07nD1xkvlQfW4su/FbY4wxw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-5n4z/cUu4Vn9Zw7EwuL80Rb1SQky6sc5D0jDYO3AtU5dVCGZ1rIJxN77NQBHiJXGv8GYRfIJRoJs2ygUXRHSnw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-hwO5tTllyX69qeI+ttGWCIrlE/LgpMz1COGGQ8wWB94G7T/pF9OfL5emLxlDjc2bhiosh9vNTBH9qY15RYIAGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-JikxGQ5jGAcZZuxnzf6ptRDZaxJatrDFe8jjs8Wk11ZOB2rgpPIWbKgKkbMsZ6ASJhDgNRdaG4bMMKoR1JUodQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-oSSes+mvNzDaym1veBppTyKtZpFyDssRwATN7vdMcRweFw0ubVPJCpo5fnFmqLxG5U54PABrIy9jJUa68blhHw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-JYLW2MD/llna3yW+KiNO/GglWgNfGxelfDP8JeTA3Uz2Dj5yEWxk3kPRuea+Ud3yGTvOiElYwYtSjvrHLyRLyw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-qbBF9p9k1i1UFBini4zHBOYZc07teaa0pAXhK8aBEg5FbxShR0z43npXyUKYF6YHVfiYQ5S8r4WsWKDusjUm0g==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-wnf58a8gyniOGvNkVqOnzTxJ2Wq4iOqYLtNj3Gy+axG8LCDEGBptPEBixCvTx3cO8klwAvvBCOvPJa7NaGcDNA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-cP2ujIMhlAkvwoJC+iQgBQl3GzXeVfUZjUSwMt9iXqfwPBIg+g7gNSobee0IK7DQcBKitcnWRY4qvHA+MloJUQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-aYNS5Y8Lgs7o5OON76iQOEMsAIE/DC5V6TTT6zziS/SdfoZO+UqIDn2ZKTovwRjjjM9Ruvd7GLXRDnN4D9aJWg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-Gm2ctdapd4yqa3G6irUQ266+VWJiFIkNxxJO/xYX72QO0fs9w8IEKdwWSUyWFwxMOMv5x06yeSfNaV2jmOF22g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-G22Wybh3xwG4wgkciWLOXF1V2Qh/hO541/K7biCBopPtWy1HKSlWckyRks1HoDofqYeeaU7wu2n//G0ntewlPA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-6KI2quzQCrqmb8gCzhKd5+N8E8SUMtp3YQCZVUbYV1MBr+uIuoPsxxJ8cV+uAzXNjYA2naqdQdayMG5qUw8nLw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-KVSNM7gXfb01Fr/bftCHOGCcuGJyWKMHPITAE1qjjRDETp4MkBhitYYX/UXs6bxQKFpc5/nivuqwqa7dcxbENw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-mfuow256kK9eYtZA/Wam7iZxDSK9wwOKs9gAWB+9+oZZLHEsVMmYLfKDRXf7LBpoSi+dtjiMD7LfV39zrtqKNQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-Sp78xXJg9HvC7jVd2D0f+B7Lq0JnvJ0vgz6MrdgbLU/mLZP88g6wqIr7aYkRHwc2P5OkUvVtM26lG7AQIPzYGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-bwPLwq/rj4aHjoQjlk66i0UT/amMoQ9y1Ey66gRGzQyHZZZAuaFdPHkzM7JwyfvqPXTQkAMD+cixp0g7gNwo7Q==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.3";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.3.26207.106";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-linux-arm.tar.gz";
        hash = "sha512-/sfiVEck3I4F24pFKjd4MidXLw1hHAADOb3U74QgYEVEYCKU+7spyRIze8smqiEW+2pCXvSkoUeey6Nk1pNS/Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-linux-arm64.tar.gz";
        hash = "sha512-7wbJJQgr5bxq0P7AqzPP5HlfltWuJT35MOfM/6AXZD7cYlwn/C0mGeaU+bv2eOQxq51hQ2KqYW6PwYyORNbDHA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-linux-x64.tar.gz";
        hash = "sha512-YWlN4Oj3rExdqgOmo+2/mSQana5j2cAhU9kd+d9Fs/2y1UEgMNblL1LCdYLWNq2Ra1T/iadXjecka3c7/XZMBg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-linux-musl-arm.tar.gz";
        hash = "sha512-2GKewfZCwsZkUIDnG5Tkbb+WyPC4W17/9A7S5DNI2k6Ff+y4HvI2n/4fbeJq6DyQnGJRajvq6tR36hyaQFeVPw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-linux-musl-arm64.tar.gz";
        hash = "sha512-f9q1IpuptkEKR0a3VNptB1iD92ZRhWQ652OV6KRbPpjTE/TJ7kozVn5PwmadDmAUcSaohyghlYxp/nJCiPq0FQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-linux-musl-x64.tar.gz";
        hash = "sha512-uw5RT8FBh4FlTq6eOT4QOFPmZ+s0PjucSKqKkmbLwJX+bLAKxvdSEo8Fm+QlqH0RPI8sxvYPAeu17Bk/GGy3yg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-osx-arm64.tar.gz";
        hash = "sha512-chpOHW7SSvTiMoiXzFYgbXrri1hL8irvHQrhE44vKpYk1U40uIam2QHTnvylhtbptzA02EZmfjQ7NURXUeDgJA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-osx-x64.tar.gz";
        hash = "sha512-q1Sr28wzzVdPMh56SKh6EiHz4v6ShpTtAFPhZHXqCqywiRyDkpKt8DrK+bTzJyl/+fupvF5ufIX1lXjF5rch+A==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.3.26207.106";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-linux-arm.tar.gz";
        hash = "sha512-pV9APsVEunijRkEVPlmZJYL9IW/vmU9Qy+Mc8KAsfPgov3KujshjzgPfzki95CxGQckSNwBsprQQC7MaAHy+tw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-linux-arm64.tar.gz";
        hash = "sha512-QTXXbJGgJGjO3FnJrHV7C+2x9Yk5F2Aq/d4qJiIaG4KP2q7+92SomqUyAR3Pv3hEc7d0DJK5lF+RJiV8MoSWnQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-linux-x64.tar.gz";
        hash = "sha512-Qk3G2hG1tq0phI/qocAV2jRIqAr0q5U4MqjwUifK+LFtbvxPADtnXkfrI3ugXxVEBlUGye433ZnnAfXf1eCfOg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-linux-musl-arm.tar.gz";
        hash = "sha512-uMBduqLNaeeds7uwC0DaBo8bdx2WBj4VxILCWTy7p3qHT8O0KifAz57wmZQFx3+i+k7auYu1OtHKbeZIxSseFw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-linux-musl-arm64.tar.gz";
        hash = "sha512-FKB5PUYSxQsrBe0YgPhKsdOu4t7betE7d2OwADfAITsS9H6gGJ5SUpC4EsrXxZ/+bnfctpmMk+E8e9p3FuH27Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-linux-musl-x64.tar.gz";
        hash = "sha512-yRDoYBC5t9UwuFtTMlYH4NmqDI1+UCgaTj/m+0hAGuEpWclg9D6/ZVQEhZRva3vdfmkf1041efgO85X9MmKDqg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-osx-arm64.tar.gz";
        hash = "sha512-h8DGOlCEbb1uuzXtXlcD0fag7xGEXbe9lAFORo9UcmaAbDQMSE0bagy0VwCdlaK47gR/fbEdqQ8Nz4TygTy+0A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-osx-x64.tar.gz";
        hash = "sha512-vrGy7EPCRHRPD42q0Z1iLtqGrKVbE1LyUVOjf11olNBVDeqsUIFS0PP0qbKXypZX9eIJ5hZ5xZ5A+gZAMqkL7g==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.3.26207.106";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-linux-arm.tar.gz";
        hash = "sha512-8Wdgso1ktVy/qzAzFouiiB6SjICd/61olH2TJYIC3gG+AIKvLjYB3EyT43qPCZdMSzvJnZTt6I8vnqMySqYtMg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-linux-arm64.tar.gz";
        hash = "sha512-lgL0cIMGlW2QJ39uydsJWDprRnpZWIuo+pWZQODCVZek5YUMP7xcUzvJxh/DxTMJsl5GSNii+ynFDrDfRlO4iA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-linux-x64.tar.gz";
        hash = "sha512-A6nmiA7NBzAaKuleTr6gDfdYqAhDaDyjo1xGFd8ySTE5/KjDuCCiKF6xVY7HGS39AIFlYIndDSJhOL3GuY5SGg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-linux-musl-arm.tar.gz";
        hash = "sha512-j3IMukJ+JacaLbx9nRXhpdmCMzhz3N2uhMzGO/v9NZiuoazTcjnegupLe9Xj1vHC8FVPUPQNO8ZwIfjrX8XoFA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-linux-musl-arm64.tar.gz";
        hash = "sha512-goZIcjbXLoXlP1zF0ZJvL6qV9W05XrQEV1dgeHvAd0KnmThN67odgxp2KoTFTw40TPx4a9ehuvRc6lw16ldveg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-linux-musl-x64.tar.gz";
        hash = "sha512-cW56k/pBrVnNAw7QWakLaEYxs2vw7OZGRQUV35TKgVmH2Ikl4A6ygbzLl7/3FS5pJgqbgwyROBH0BSzERSxY0g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-osx-arm64.tar.gz";
        hash = "sha512-whvgDXbhNV4fiNXn94aBPpe1Yf2MwQQ1b86ic8hVOJ1Ccsjz4n3g8Ne3WVafLHg9QtGUWQ/6lZxGo//4MXRhlw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-osx-x64.tar.gz";
        hash = "sha512-A21Dhd/gYrwrI4URqEKslaFGJvZEAh6nkTEjs8dwgaOIzBWMtU3pYC1VAkSeQVm/TBGoYQalwSlEZWSW3jV6jg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}

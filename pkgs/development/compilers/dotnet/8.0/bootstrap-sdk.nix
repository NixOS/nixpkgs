{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.25";
      hash = "sha512-UADgNn3jhsot29Ve5n+8E/J+At888zu38dfKc56TsMIm/Kb0ncgfELgYwSwUGpKI/nASq5XHow1ytueakD6XXg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.25";
      hash = "sha512-QBkofLhL1n2YtYtfsIPGhfH2NIr2su0QXJdaX2hmn8BgxCuKhZyN6vt4pp3rHxudqFT4xJETe3aK8UiqQDsSSA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.25";
      hash = "sha512-fqnJNvz6zQ6c5ZAQoKFKMSDPyNX+7qzn9KUOw+a0PSlMDMBVj0wiXHyuo7aqVq7whII6kd2ZY9rhbhRogeUNVw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.25";
      hash = "sha512-Bzai3fUDV4ffDKwBEBF2IhvOiYbKUKFMnbroIeIMyHs6TFMqeHKLJ3LRy59HZT1FrV85gOnFJ7ye+BD28dvEAQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.25";
      hash = "sha512-d6UrXl6WRQsVr3dvW+pMJs+N/lPeDVOSum8VTkgBdWfFLVPYtKhrpKEJwdM3odmBqpcwjQDtc6Q3/8yz24OsHQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.25";
      hash = "sha512-ZnOPTA2KMqFVZ+0Je41JBUMtj3jbt8jbqpdyWrJ5YvpDH16aAb2bCZ3t9jjBqTDYK8hi3GKevkEouvbbFKzQyg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.25";
      hash = "sha512-GkqlIMmnibU5KHYtVcYLYc5eERO7Ql5G3xgQYG2dLdTOYBiSwNmWbg2VljJFF7XnoZ4+iWyVekZbkzv/0auQhg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.25";
      hash = "sha512-VRGk7HT6e1UzccMH1iNcc3r+8NttP1XyZFDeXwQRc5833AkkOpfR2WW91muK6ksC+0EKOaVAJEhmWDT4IalKhA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.25";
        hash = "sha512-yfwiS/eIzv2WVcTwtFvJaucR1r5n4pmQ1ae0SWXAVS6KGVGUHjhRnTyOCivuXcRzjGGZgQH7CRw/2WfSIllFdQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.25";
        hash = "sha512-0cmoZ6fj2gbWhC1LP5XIpEXwQzlsqWlDFpxjUgwv/pVLe9HPeJWt5Q8Rqui3RO1QNE2CLqrMoWxI85b/apKScQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.25";
        hash = "sha512-2906shiCKrL5CSvLaUbFHLr3ZmtRZUfHiAo/EIivDZTJcfliWd27bvGsgVm0R5tSP54E9urxrLota6pOCr9uFg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.25";
        hash = "sha512-BkKYjJoeBKLKfYHhmqIDhJ3tHlQ9wwDAq7NskffCgkaJh4IlCBMCWUDXmr1nNOW8NxaONioD2O0tBZ6KhzQ/5Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.25";
        hash = "sha512-nhohobVJGwv4RymT6JtleO1yxFgp0BoSJKqiOHCnybtE0uxIs71mVp13RGsgCvcWDV1EQ9GUD5KHbhW5a6CbdQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.25";
        hash = "sha512-soxRquFCYg4YJaZ8CL5LWWcjphJTCvj93vl9a9PMNmPjnN6X1ZxX+75LdY+ogrmb14Sw/qogV2HNMJNYZ/wbHw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.25";
        hash = "sha512-q/jFyTR3QVUi9rBwcbzv7ocvdZnwBNolcv+7evQtI0MTRvfi6f5R4G9QC1roevAGJEreMMqs+IbPPwI+X5pzVw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.25";
        hash = "sha512-fraXubuYMdH0lR5Qnj79BWnrgYSWUIdZsuR05Q1Gr7w7EHwDU1oTxk1R1cr15d4QECQfm1AY3ZLMSwKHE+GFSg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.25";
        hash = "sha512-qNWyQUL5ibXxxewxNX/6XarFtvNIfnrodsAL7F+bRfa9jzoUTlvwclg8e1dyEA4zOeOAcivdFuROJ7bZfQ3kDw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.25";
        hash = "sha512-d2PQ3UJyKeSwu8Oq931+tOKC7stEFsotdEnKbHacd+powcm9gFiNvu4mpUNk1Qha0v9YkEFrAqvjXS/nt3aRqQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.25";
        hash = "sha512-rr6lj09G6Mk3P8n93Aa7XGHJ/2XchaKgF8V7QtFgfLWeIUdjNVzq8him26sOQGKtaMXn/hLkFEyweu8carA8Aw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.25";
        hash = "sha512-DtzolCQpaL3tGzUm5tSEQ8+J7Q2r86zpS1CM6jABeOChIDsDSwfZ8oXvBflybSth7JEnwvnzQWOVov8Jhru6KQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.25";
        hash = "sha512-k7mqLNAJItPKfPPOnoPI2p6cpjfslWkKk+8KkWSPhsJRMKnR7/8e3f8y5/ToZ0oEfylxyOoGu1SFE62eMzfYDw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.25";
        hash = "sha512-8FTqcOAKve2+v4d4G3LUK7yU8CmW98Wv2b7YPMD3WH5QthHcnecJiq/y/kiA8vNG09Ir+DauJK4Ai14zY4gDTQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.25";
        hash = "sha512-rqSJrkkr7OnfqGiqbuCTuBbMwJq4ITzT6dLR+Qz9wEA9dG5B4iI5C5IIPIp+7fO1BkKS+mCtR50sZ2K7sxhEXA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.25";
        hash = "sha512-HfHw4m9FuU3+f5URxlMDi4T8vDKQkdCFR/BMtsfq+84JTAPINqkVFjwdtC6H+sXlX2hA9jGSUkjrwYm0GXdjGw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.25";
        hash = "sha512-bpXPJxE+om30rajR1IA1TNqF4IJi+md70jLMItaQTChivdjJOVugHZDRUJCeIVp4rBglBCSutqH/FLa/xo1Lcg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.25";
        hash = "sha512-yiU1skELDDaZcEzHiHBqq4E6pRzuoam3hBLicFx1yROyN++y203yiQDH9nEs0pOMYEZOZQEMqUF5r0lb70b6iQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.25";
        hash = "sha512-eZ9rDYrduKOAzA0XvmJm24IDsI0sDUfgDI9JhM92cDztXaHenaZzlDFESUZJEHSbEiWx9a0wj0C8nS4BMUzCUA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.25";
        hash = "sha512-30GieR4glcXhFNWNdJAb/JmKp5xTRk0rt88pEwa1XZjpM5Kzjo8s/V6VxMkePPD6k0qS29MrpWE4wqMe85htew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.25";
        hash = "sha512-XEuocp4I6d8A+8c6t1OyDl7qDs1zV6/R6AGV/lu0f69cXItdVxZtLvDjzYW5TBeQ9Tx0r5PH6Qid7Pq/OQZysQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.25";
        hash = "sha512-UDSHypbfdYcq5mzR6hDGKmvyDX9Rxg/qKfWsbfqaJcqE7Pz7PbmBzPvLpRc5ctllsdH6Gy3YPcRuUPuHZFNPOQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-GIWmk/+AVDyoJgiFtf+FcpDSLWpTtE4beLpP22qwIyE4eFZzx1qDU1Yr5SRsDrSmgf5F8wrf7IylWJs4jwFaXA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-D96Tyfln5axyYUnR+HkaNcaQmHwU8BpSBDyX6XKjlN8Y8NpTdLrBjbocpe00PHdzX/8QuryY7lqpwtG0WMW5BA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-daYe+APwzRVJbJgI6hDok0JdiVpT3d3ct5wlA7reVTAbPt3Mp2P82FCzWF9TigAjfDjC8cXvFYTsXMJoJqsU9A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-T3n/RBRo8gtkFpFtul9CDitghlBTjmRny4jb3a/rGiwpvzAo01b9hDBcnk+CcAoOb2CPvlbeleuf5QRAdPGKyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.25";
        hash = "sha512-OW0ECKvCxfK0SPLWgZ0BA7gXiZUUjIx9KzBklg78EGZfiP9EYPG+glViqmRkqc1gERQKTuaMUdEL7Rhe7z0lOA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.25";
        hash = "sha512-7Qa7XvKR9VSBFk1dllIs395MQ4Gxl0RJqk6cyBAlG1PpIq3kju+4u01ug7C4eJGcVcjmzRMZO8YIYRtpyN9pdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.25";
        hash = "sha512-tYBwWufBKmR0yWGZ6VHEEFQA0z+7n2jpfdphH37KDd/qZy1lgyut5ArI3JjTtlQYQgfL3hcV2RN4APaULYl63g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.25";
        hash = "sha512-nFnoLX+jwF4HXUC4Jry2mK6BBzbm2LTGw38LyhqFRzcEpe8sfNsihXlHx+d+XKnDy/axQangzRi4C2LZ0Kg+2w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-t+smpWUJHdEv98JlFYD2E1C+BXyFczA9LULzy3ZDKg0XBVp/zPmfo4pX0kCCCTfpmosShttU2UqEbIH8sFCDSQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-y7d6pzVJsuGmNki/MXfvKcvZXMC2ycRZ+fG4xRQXEQu+8WvGqcx7NLEAfia772iQS4LNF1C9bPHZlVUDXsOHoQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-sTmuWB5gKE/5H7HPw4rKWlSOToqgwmbq32KvmPOUOaXG1DfPQJCqXwhIuCabL579diYq1v2eGw1e1dVWdKuXQg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-LdtcUpGlqOC0cBf1ahtmYdQf5TOl3oFuVDk6mTkuXNUhXyF7ZWtrYODU/TkSRjr5QiqQimHSOuK1y1xHer99zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.25";
        hash = "sha512-8CSPcnFMHKkpJjCUS7GgWLWmjfqH9AtuMzsnPNwe+lKIP2HxDwgd4Q/jlliZkv80DQ6YbCRSjSCTg4j+tVlpqg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.25";
        hash = "sha512-s6WnkKOwSSD1HDmQGrk/VOEy2JH0qUMp442bc0MAMLdzvZOLp3ETS7zObJ2kBmB9TqHEjzcybCjsNbApoLDLFQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.25";
        hash = "sha512-vaunU9Pxox7xBrR8hJ2THyifEbu9d1tIG5eXqr8XTZIxxJiyshvYF5nn0uiTh1C/FoogvkllTe4cjsmcqBVqUw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.25";
        hash = "sha512-XJTKpxcUhrLt7TaoBELOb1iQUFYICtakHa5pK2vTTgcsb6GpVxYFvzyJDPDEbMdK9s6/iyKysWi1o/MUAE3qKQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-hn4OAd2trVQi3EumT8EOKL9N7WperpZ2CR7YLeob8zxG21kLDKzbJi1+YkS4S/HTIt5o6PF2+ag6OyzBte3a+A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-U3h/rme/6rxpB0yY6RV0NB18pfkEI/BNkYvRYayVOiUzUn8VCpoS57MXb7ybGuzelBnm/BTIkvOCPPUgbOTpPg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-V1Y/+La7P6tCf6IOI9qsk3YECGWbNHfkgiq2UImqw3VXRUolrsabSnH4Hfuct3UE20zINc1ht5YzJ2N/Dua5wQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-EMJtrTcualEAZfCJXlCjnQLxCApd9ChdauEeibxPqclYfEhTULXFKxPUHjmmFmCd/IwdDEVSNIXz+RtaorVC/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.25";
        hash = "sha512-0WLXarvW7HeX67KVelSKgZ1gwaYxbFgJZRSVYPWzGMHOsC/CKlL3z2Nb9JKsEDuveg0RMa+VrzbNyuygXEL8ug==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.25";
        hash = "sha512-Ed/m7srCdqbWQKnCHN/S9LoeeAtenbW0q7sZ3t7bEkPZqQeoYl5x4AXrjTTFyK0+v7G7xFpdDU5tJhLCjMAZdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.25";
        hash = "sha512-mKFajoj3yKTWCflyBZui0mVyLyP78xOTdkyW2NPz/Gs2+qaEZlZVZ+0RJ5BWLjL82rqKnF9ATBSolMkq1pIbzA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.25";
        hash = "sha512-462gL45vRTFbJIjlQmA6NkxnZbJZxXvtv53iya+SQQ4VM15gSgelR9m8y1MwDIciqThtD5x3nm+3BpamPbaryw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-kMo3dz/KtKjf1npo8s8niLjB6Zk+QSOaAQigo6Gm9kvmLAe8eVlyrqrUsXCGK/leNdiGDWzch0L+nxoATpKSHw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-0WzPkm4ykvpRtHAL73AzNOkU4oUB3SxFsCnPHV9WkWbpG8dGJri7Z3MweCucdnffA8WyIcaG8R6lwCmgjGgp7w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-q0wy0rMPDDCRRSjL/D8tEovs+SveYQL6pBa7mME6u3JgMRN9XP/PQwGnxahS5/07/D2RR9nAK5qq9xhudv34FA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-4N2e6Bmw8d/eLIisGGvc5wkdQ61cphwfNGgQ/99Dsfr0/kl3PMovG8XscPNEmZHbKPWlb8pfCcE6MOiBSomwEg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.25";
        hash = "sha512-DEaIWo8h+bRnPFsuO5F38+MCaSF1tnulteC+6d6LeDoC54W3K2qUFgH+LR+K+pSxu8BMSzGNSWPp2YJdcZ0GXA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.25";
        hash = "sha512-oAI0pinclefbjLR55uxCU4lQzJKuSwdbgjs5fgGnECmXaUvgXhtGfw2ZZqs6xXNTTrciiLbtrj6xVtnQc+yAMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.25";
        hash = "sha512-R/MYKiITDkUwmgStgZj/pQIis6EYrhpha7pqtgh+BUPN2nOY9r55ZgniV+fnekra/79UF+7ckwvZhAi7qh8/Yg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-cJx+UGgTgS7eLtctXtY1asaZELK4MoAp45tiFtSv99uJPTYuTcPj5nql5c5qyV1O67+M88j1COg0df/b/ADdbg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-eawUKDA8m6mWR1nC5xz428CU9OpFDheRDAAiF5XR9BPOXwCGk/lnnYfybFQ2owchPP6rRfpy3QPo2Mfh4Uc19A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-p+pERqwKzLrQuD5bLZ8Baph/wSBlVenjTols0os4A/UzgJFUFPV3Yd/bwIodS0Xu979kWdi/T7R7UJ1tIDprZA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-QVvfHc1zDq2q/BfEMVi2GZMI2Wh6KnNFRwhwTu5zvkM5UYJCOveuUD2vtR1Y0OYKJDumD0wdzvvGh+xNV27gpQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.25";
        hash = "sha512-Kwf6rU4HTiujXCinQoLoMwT6tNU1mlSI/1Sg3dVTmPimhVevMe4sBJ75dovoc953W2HBrpGKLwEQY/Rnp8J62g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.25";
        hash = "sha512-ZsUjIrLEGodtiP1D9niDnCehUjn3uY21cqVxfWW+qm8pePL955R5pdl7QEN4uY4xIAtuEFPfiXUWb53XjyYcTQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.25";
        hash = "sha512-cUilAUpHG535Zs+rW0w0VkaS/MbjgjsLGssJKdyFCNehIdR+4+RU8NM8eQNIZaURqkdywu9mQHECfH4Yk/1NQw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-SJJ1dVtMi8OC3/BROSdUbuiCF4HcZiD/U4eH5OPjW3xkBsp23bONvjAKHGwogK3VC5ppolVLSHtSKxVEahqygA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-0H2OFbTbBPsf0P2V5DXfoZQ9aB/NTT7ptBVu12t+hn3p8rTztSOLKvgFkB7W4H/jFs/q7gx/+TdxrAMH5sTI+w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-9nsf3lm+4E3FT6tB/FJcci0d6pLRfpvacHEFYyfQIAn0CpE6AxfNaS988+G1f4whvf9BH93Ksr/6zid2qYDZ9A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-A/l9S4D7J8+b8aQRBGFLhFKvA/hursAM+he4b7H6sacsqLBX1jKdKUJoN1PbS+uhSg5mLSqUcmOJi2RuVgvf8A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.25";
        hash = "sha512-cYltFLxAUdDdZ2xkHGegVCRQLz0zD7jBsepmLKCau3G83jNvEk6ylI9uLlD731+LRT0Yq14oydbSxAQ/yaK6TA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.25";
        hash = "sha512-9l5Gtkz1kOH+cLgUDnmYDoIXB75lIQ39vp/6DlyRxm7PqNLBP3PXuNNHnGJ/cyvy5nER6DExV45HCi5A1aKr/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.25";
        hash = "sha512-d7Uv5YGawAHbFPkwIz2RuGDI9+74/zwUOdF2AOZ/tOIYmn01xXnVMeFrf1Z4FMgVLFdA6nZTAMy0WFANXojhtA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.25";
        hash = "sha512-UcgDIJx4+Zh3yNrnwDJoXlA9IpugIUDp0niYFyw/U18c9jI4MT51YGLGlI7vy7IkOVA7O0mJcLABrABLKlcKbg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-KLZPRcwFLqUil/QaPIE0CSXIXM5e1olDQOpWXjBWkPuEj/8zX5A3PFuiowG+8yoC8r5jP8RzjwdV0Y/qeAsfaQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-b4iYO3mLGUU7reVLhyji8jm8ocWrA3YC+W2bUxQtbl1xCw9jEYtVdqTXx9HNmE/71mGDVPHSvgoo1tnVagVMzg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-rWtj0wYv4/WfBtHLiaUfNkHf1j+fDGqbJrwus8vPJ2SBdQhqdhJ0km34tZw6yRqjE8/QK8ZCnMW75fuXIvO4UA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-Dy1knVjNSOsXuo3WiUGeEfTFM4pZzc7RU6fClGJ6QY//B5wxmQ9O3UjTO563XgY3zdxqqAIiU2+PRajXKMn3Ug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.25";
        hash = "sha512-BlhX9ZFiZiLJjsnd+u3Es4SoF25Sseh13xVRuX9qSj+zbdDT0WrSc3AqKhX7T+iHYHmOvAhF6hVioCOXX3k25g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.25";
        hash = "sha512-c0jEySkvlVvHmH1Cst9CK/1heZt20GRwOfItWm4ng513VEfu0EbbJ1Z2UYxgBOvDruCdLv0z+lLbS1yxZdsyHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.25";
        hash = "sha512-aAwELUtrEsgixKnFRYquT4DFu0DPevr32SfSI+hkjF+v+TA5bbw5vJehfgaa/g5ubWsmgsoLBNXfmdygI74e0g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.25";
        hash = "sha512-iufUmvbhlMAtLdFwCU1LFA17fFbhE/eYg6dLVxmPxvwPDVEyOoJqdlWQAH4vvOh8A2gTbEG56qSSWDKmUuq37g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-qILNnBa5HVaQK3Qnt13nUcpU5RxAjCxnmXjgBE6VgVGC5vInaj6piP5nOEMQgg7qKx8Ia7sO6b0zNfpLqpX2GA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-jojJqpPkKEfFpAR85UmaCA7CfF5Qg/QOUI1lYNLGb+uhci7QKLuljMNpkM8cLB3oYXR8rqtO8zW4VF/WWXKGtA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-GTM9x1fhwXHEb8C4SjoFSaFH8jJJQtjBngR1X8BsPmSzQw5ivbtzquShitymrmBZN0wubh8VfqBW1IoiNRVfyg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-awiQPtoO8oeDUfXublVnsv9NL2RnI+CrX3Gkffv/c6p6Mgu1bZvCUfsWZ1vigib7LMEHa8aksTtiw3rOSVxazQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.25";
        hash = "sha512-FoIQgcIP/UQMIgPDglDd3CwTeeABeHbeZwo92tVikOHfwRoZfJ6tU5CsouGD5OCSQp1tAA9NUqDWUTZw8zChDA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.25";
        hash = "sha512-EpzOSe9pa+WjHW/P8+3J45nJ93b/ip9M90jn0R+iB4Rc28B2Pyh0jAtTqkHZOp5oMtznipWY5zuRmXbgFpUzAA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.25";
        hash = "sha512-Py/14ZpH+MnNYQ+IM98CdSGOAu10qI+KuQpVgPPUnPyxuTqEsI/CG2VeHa1l7Gvz/BCADkQo8FqgNJu8323MEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.25";
        hash = "sha512-gK/53iv85vbUPb8CnLh6PPWxS9EHwtIPPPcxHFKTgNPO0mcXB+e3P5svSuEvfe9Yp/dE4l2E9UfDugcNSa8JxA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-pB1agArWNDwpK1dctWYsoNfUkQ9qUH8J7l8X6ocVFfaa4cgHU/MYT8vQ1mfjIPEyXWC/ljvNJs74lqnh3jhybw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-LFwA+JpKwhlFLvZXnAUIbIdTQCRCOhBUHBIzonp+rXEvXx0I82z7QZ33ujNoXSa8VZwmhp33CILo9+u2gIg+Lg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-/iBO/75csujkLRenu3NrcuISyNpiY3NucZ62PXspChFZxI/2Hd9HPYSXrxyjcbiX/SXlFD/zIyhpQtfJzIxFuA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-hq84uCcxOWYHhG/BuezuMbjeuZZddL72p31TwE9K4WWWnhoiXBcDsZcc7j43ClxXtlnSZIVvWerDfZYfRiyJRg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.25";
        hash = "sha512-gviCU2Sq/CUzGDp7kQauzbMk5cpoCgN+sh6FpLLGJ4IVchyeqq7UQUamnHtqIGFJdPEsqdZ95cl2Sdh++uBlQA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.25";
        hash = "sha512-ausHdlWALgtBF+mvt3vWiSZq4KqTreVPmDtHMI2uarGb96M17QWu14uhhctTrGsPBcc7x4hTYBuK9V43ArUAFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.25";
        hash = "sha512-UkxLgMmbfnG+xF0G8t1Pd92UII+9KqgmxKNzejjTW1Ox+DCwrC05MmplM76vLsDOdaO87is325RbtdNRSaiERw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-SKdopTlwBgWYqPT37+5Pbe6IKmznsrwA1zX7kua4PB+DdbmkS2b4nYa9DuZIgbCWWL3C+mjloxSmFzK6lOBAhA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-yBgoCW+BBdwC0syp/FQnIkvehxFuJhPPrIoXaaOfMaJdABNE2fV4QZ7t25um+GKAXhQSFYASXZTk94nrm42KVw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-A3bIR2BHvxFOoENcWP5TqJAuUBqDwOLgK3fa+XtFWu0Rtp9ZrYKyRoHVbqqHirWWvzN0HWOZI4x4OaFas8kfFg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-h5Ek4mjDjouQ4ZgoC9W0kh7WzwYtpSJrLHjiSUkMu2SE9/n5lY27kRtPe+A4r6rzLfEEd35SToq20nO3vK3kYA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.25";
        hash = "sha512-WSkPeQpku8Ur2WKUsHMX7vxa9vmxSNw3XtO2LA/9HxaGXqgHo9LVCRffqBxIjz76vKqvbWjZjtTj8eQ8KaTtYw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.25";
        hash = "sha512-n8aPpFWVirne/jRH2/w9+q1+mUzyqodJWuSJBRi2LvvqR25LcneuBOk3fvL2QOn/HDsAOoZ50weP/bay+iar+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.25";
        hash = "sha512-5dlpmlUU3S3Y7yB7XfS3TJZBthw9enB6Jv8I1QptRGtVr12wVljSmkUbUE5tujou5im1hhlxKA4LKO98tGynHw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.25";
        hash = "sha512-pxV9H1TBTznSSjg6EJUwh6HzAHN13sPqSFcLznfoTeDiq+VFt+vbCbuGR/QZIW2fiT85sP89r98t0BZlH9JG8A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.25";
        hash = "sha512-IZgxYw2JOLsXiDW6/AEi8C7GfbPllOsHssqcG9PKHAVcwlfhfVI+ZWjwHJlT0Jgv6239+2NKKUxMje1g79/UJw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.25";
        hash = "sha512-qX0vaUvmMLiyaQ2EUI+khMuZ6R1lR2HLZAUBTMvxlOPccfP0VoYxQKEZFKp4GuyHtwBdGZTtPB962wz5hhjveQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.25";
        hash = "sha512-GNutinDHEuMwy1oDYCZ8huW/0sfCDHNwE8/dKXSpHdAymYcKqMZ6za9WQDyh4ZxW4LtaHKtL6/wDx2ksHgU+NA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.25";
        hash = "sha512-cJbqrcQRgzXO0GfH93xRApzWTlb/lXFngDc2W8ExcLMzEOcF3nZBLhe+w8uYKeqhcEM++HzzwY+vWOPllxqvaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.25";
        hash = "sha512-qVmF5yIDylqNTgRgpveqPK3+QYeLmKR8ADQLi/uUpOebXg5MrcxPdxM1UiYlXLPzilOxPfbkimrLmXGdHEuMeQ==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.25";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.25";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-linux-arm.tar.gz";
        hash = "sha512-2CL6ZEB474zJGgC5YSgdYr85JsUwwgmMSOKldg0FJjYz+E2UAYzPbJXJlVNhgLscn+Yfl0cRHqyzIVrAlIeAxQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-linux-arm64.tar.gz";
        hash = "sha512-Zdixa775DETarJBqr5KBj0OoSCGR2/PyC93N0a1gd9F7YXg2S9CCSVAd3TAhpMj1+YocA2DhJocNsUzwbNEnJw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-linux-x64.tar.gz";
        hash = "sha512-3bZqw2YlKrOCJxJBs+U6dSAdLISMnshwon+xeKbbGOTZSbmJaj2FMNA9JV9P1R1jU2e+3aPZ88Z3y1lnhNvLnA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-linux-musl-arm.tar.gz";
        hash = "sha512-0vNZqg1Cs624UprqiWyXH9+f7tDmeWZZAQ37Uc8VO0njBifgWkjwlWKXNi+gWaaiNlXrkYXjmfFT5obp+C7N4g==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-linux-musl-arm64.tar.gz";
        hash = "sha512-EmsxuLof4zZN/Nk4jHJGX6ov23slHHgxCG7DF081YHXnIG0z9I/BrjfDNdyw9zm634JSE5Ha00xkCh+xlynWGw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-linux-musl-x64.tar.gz";
        hash = "sha512-mUQw4j1G/GSOqWVzscqy8RWM/0rtf9PF3vUrTmOoT7FjWr/ugyjS+TZu99S0LdzZCaagKK8TeK4OtUlQSpxXyg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-osx-arm64.tar.gz";
        hash = "sha512-J4g4l5Dea2BPrvUsV4WewpStGYzV3ZuMSu0VoVy4E3ywUgPBdFaCeSZXPc1mvGOqyM7gXSg9hoZ2BC1HNZMjIA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-osx-x64.tar.gz";
        hash = "sha512-8SDaBLm08NnoXr7onX08bTk9f69j60P7G/GQ0GShpShg0DIiBbKjhz+3yBcO12aQiU5nU7T8JoxHzG9LfKuEIA==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.25";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-linux-arm.tar.gz";
        hash = "sha512-HRg683h9wTLbngLRh7nNAZzwOkAnU/pJIbNHEeOMX5FJSwa3nxB3wlvFu9ipj7fHjEOy5rBKedQdtTGFSrm+7w==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-linux-arm64.tar.gz";
        hash = "sha512-7tI/mVisrdxuS4OO7XX9M9LFzWb8Z9CWoFxgvMiDWYKInSxVlHytxHybz8PaRl0wf3oD4NOrZoKxYiM6s7Xcpw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-linux-x64.tar.gz";
        hash = "sha512-pd4hhX/lFp7HjHBMcWOp1kh6dVOWZRwkEtJC/8JhTHVxGGysTDtOTJnnvfcWZ20opZ1JmGLGpv17gYDR45lzgw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-linux-musl-arm.tar.gz";
        hash = "sha512-LAt8fu27DwYLF/Ir3BGNfQuAtfeC1MOd6CZDYpMhQgJ9Sa/ONs29hyLgvYKLwWKl4eQH2MT6DTJoguQ9ZVazRg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-linux-musl-arm64.tar.gz";
        hash = "sha512-Oql0IFsj1f2tF2E5H5LbAFbpjcffNPvNm08Jq8pHAczXVyaSuzonxIsffa0ncL5QniS8iauojCH9JFDcM7jFaA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-linux-musl-x64.tar.gz";
        hash = "sha512-Kqlnc4rgRGHONUy0hlgte30u11IeJlusD88DiAM1ZIOo/CMuQ5a0R8tcVbGLNDcn57KSKsVmHaO9LbXeDHMWow==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-osx-arm64.tar.gz";
        hash = "sha512-0gNqLlM+aIoVFkNJPCVIg6lV1U5QnjDLuHuQl/eMpMNu4rgDoDEM1XGwjJqFxpRQTyZcD4iE+bDHmNx0n80cow==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-osx-x64.tar.gz";
        hash = "sha512-zWs+7FPz7wHDudJCgA7cMltEAVLLMkxwo4DZwhjQkYRp3R+eaOVYg/q8cQ0k8BrOEpubIGiGJqJJcK/N8IR0Nw==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.125";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-linux-arm.tar.gz";
        hash = "sha512-qOhXRciZHNWGzLnGwmLgBp/SjPjkpeRt/GgX8Gp1WaPFpHXSyVCrC+yeixxRaavXJrRN1K4Da8+vuhlcJ0WpTg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-linux-arm64.tar.gz";
        hash = "sha512-sbLwkjJUAcwxK0Enb1DhiLAin2+HQgxkjRqwXahtxAe8koqblTztFad5z8r+6eNPCACUE1aLA5nHJ/i/cbccvA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-linux-x64.tar.gz";
        hash = "sha512-KXOFSrkK9U8sYmqAMvTftBv+3Vkh8dW5pLaDKJJ+eF5ciqaT0k9zkwTKRtmk9ahAgfqUuEUuH0+DBAqOWCorNw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-linux-musl-arm.tar.gz";
        hash = "sha512-ld1t8kFRa2ZemOsirZBRVf+p9G1vYcKkNEkbc0Jq0Ii0DlfjkATmI1Y1dYDApgQGLMdKfCWz5LxHGwpbYiCDOA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-linux-musl-arm64.tar.gz";
        hash = "sha512-+pcYdflda2H82w5lPI/YByTsDL0218Dy1i0od92g8MmU23zLSclJBzkDuoL1gJEDEpUWMUFTuGGtx5uJvjH75g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-linux-musl-x64.tar.gz";
        hash = "sha512-0YcLJj7ieU4NcTkbnYhiptVdxcbVHn+yxuuzwBerwASmMuE4MQGPUkjhmhXTcXWTV4ycdRxNwg0SNR5ACycTHw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-osx-arm64.tar.gz";
        hash = "sha512-9qxDRPN0NM4U/JiPT756O5LfScjQdXjHBLFBX0BBArCi6kSzmJV570Pi3njluMJSOtMFDya9PrHDGHwnyEAOmA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-osx-x64.tar.gz";
        hash = "sha512-t/EJptjfZlMh4HV1TJjn4jTzPe7DeWolEC1wvHZ1UWDf6KoLHjiTE0U/VGPzC8G8+EGZcMAamR754YF57dD2pA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}

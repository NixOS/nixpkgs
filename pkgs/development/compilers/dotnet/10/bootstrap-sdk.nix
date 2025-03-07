{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.0-preview.1.25120.3";
      hash = "sha512-7JQ6RIV2MP62co7llxdJaHfHxZ1dovwMT0OZ8hqZTOIDBzvhsw5ZVZNIRO+YIPSRcN8sOJDbo9j0NZ6CwNBDEg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-preview.1.25080.5";
      hash = "sha512-0B8cvn3YHXRu3o8/I7zRvkvtu0wWis4LW7SV/+H90egLHZPaOfovoGNCvhbHjoTXCghv7S1xqqm4hMgoM6VLGw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-preview.1.25080.5";
      hash = "sha512-WM7Vx5qhHEoHVSlzwLHcJhKdlGgva0JWQB9sIdPPfxrb41pOYbTZd5NkU6iUx4rOCeVDz4qFKiluFt5GSR2Pow==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-preview.1.25080.5";
      hash = "sha512-RuW6CgFdHTLjSuPlkXv1HVAOHhuaLlmMi31SjfuhvkiAXoXeDYV9VkNGAD6vv7pg1BPsuFfibhk4R6GYjjaW/A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-preview.1.25080.5";
      hash = "sha512-bUaQhF05n2j74fvvQmXlJZmqJfb/YXltOHps8XQZ2HKp5EOY3e6ijEFqXnD1R91ZRghqy2ADwUp5qVarOaMdXA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-qY9/zo3KRmK2ArwHghHuL7R/a6BUvDq874D4+EK78k1sU/vHc5sl5vkkxEu7vRrwG0UUXurvxwXve3cGPjB6dg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-vgkB8yUmJw1w/n0uP4FhvFOZDWIkPNJAfakhvn5yVZMh5VqnCCHyfCLb9edXtFWmpC+SMEyCT0bqSHTcLMZfNQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-c9EJZR2W+xHmCLrS59Bdkp2/Fw4DSAVzwBt1uuNAQ9XXt/f2REt/osXj/EkbOCyQAnxQ4J5v26BG1lpxkZ1IVw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-kMS00bMWu+Coioesh6AGeBekk/nKt/UMCwsC+xsvScdGjGJ1Tjv8BMsNwAshMGEwdlbB6EqJyO1J4CPPPK5yVg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-qJBeqbHV0876+3iAeBt0bIigrcZYIAqU2cay50LnTUmTYFN2GJdhRFwQIKjHtH8O0vxQaP9Y5tGfe7U9Re6YPQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-DoJiWclBLGaS+xcf8R0lrYex7c9DnUB/2OOthOnHeUdeuvlEr7CyKf5tAeBbO5yGTyMFP4UnhLtDmA3j1NXYpw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-eVTyfSgkeihFFPfkX0HsRWbgVE6JTQxBfZbke79J5Aw6r6kWS3FR+GkloTRmsw50hEhxsNug8B/3a/v+Hq2qxg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-U6G5uLB4Gt+QSRVt9tHGpgK9u/h0Kg8gbR3lfmC/TJmPEGd+7pMdG76IxEIi4kF6FLrHMphriD1vtKbfCIKQBA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-1YWLHPYBEXma5rFvZFu500hxmDTs/wSC++zYZ1oUkMbtas9Tzsi+F28bkH0n98QwDoxjAet9vub90XIpQIUm5A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-3k1Oh2b70m3yQh1T05Xl42is8gw/p+7tMGtXmj93PDorqZe7kjGT8l2kNBBCjLsCzBu7PW6Y+88zTzi1yyh/Zw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-HwBS0FRJFpEqrTELxYh/zKEHH9/q/DbrBVzrHZ9RdHRX2Ft15oioe33oInecTO/+Vh5AEXF8n1afc34RCPJluw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-ITbXjFbm5fN66SYHuNeukyBo2cHlXqGvp/1aajSyK348QDtBnD7mH7r7jQHzKBwHsFJrcGGFju/vf08/ENi3ZA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-bp432DB0NVMIlz9LRohJkF4gc+AJlW/+6nEveEuFmZlIjPxN2KaQvu7QYOHkb8z/J9G4jXJyyrKjNs9AlcGXzg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-fVNRllQBrnS3t6LX/RMGBcJc0CnBTAxtS77qA4jX52bso5EB5MfPbCi4BxZxWzjEMf8pSSevX1RXvUGhdJldHA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-ugo0QgUPcj4wN42lR5jEZZSahxDp7caQhT4MGHHxzEu10U+dSuEiG0Wf+YuiHsrcrFUEeFhgLcdkUw2S/Anppg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-IDQ3HJxDYMV6SYnkSWGfy0eEH3MmP4YonaRVBxDmxLT0Rytv8ZJoWPbDWs52RXeI8y3dAhjYD84ZaOeREwQ9YQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-VWg5J5BNzoDeIZ491JkY6anNjuKQaUr5TgCszNnCp3jPPiDVSeCf3Mhk4EZ1fKC/trNcEYgW785b9URshQhTvQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-TEMZtKCvJhq7P/CCIzISYvxDaW1o1jcseepquCbrYSsrLCKJ7WNE2zStqu5HNh4VqiszQ1BWjLTdbTPKjdptWw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-vx4NS+RHj+ZEvhqJMhMvfKTWAL799sKjFaR0PY20C2hSXxdMyxi5rIR/XGgdPwF0PcXMul36KVWFssKA9y3NNw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-NYnDi9YcfGAZ1qXK6knwsldUTR+92tw7Q6MXq7Sted3rNXRWc6xy/zezOrFP8OjAdn8Slz5PUHFDz9BdGiOuLg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-2tYWNqQJibUOWHwjkTsxfwRd+u8BphDEdxNVBU8HLjcoSZbONXsKHx+RgBS4J52mRBVM65BArJzZ8toIenEaHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-E6FcxsPYNxn1E60s6jnxFTRxm2thvgE4Iy/rt4mgNk/+mQ+zmwLnZiDiVCAnxD6Cl/7OWRPCp4Yy6csl4PVN4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-FNAL8V9jD16HGrYatWUxN/IjaipGYC0WJ5tMPgC+ZseDNnDU1XT7hE9AW6ZGnJRkB6pEBSl/D+sCurrLPWFNWw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-5xXwUnVyIedqRN2/u6mJTYQ2aEmL5UjAILayabKaVfbfjSDKyrtNEZlrHYxGASh9nkPRP/TesYDkPnOOXCdW6w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-4Y0KWHx7QySSb9oTuqpQ0rFEwmbW7DC8BMYzXE9wYkCCg1ErXZxdrNCWhuYj/lp7T9AYsFC3DFvbzAZidGj4/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-w3WGynXeGdTuap8DrGOh84JUHNpwKJKnMt9U9MZx+zBpaB+76TV3JqL78w7fJWoA0UbAuUsmXXc45FwiEsYhvA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-2rGKD4/VJ5Xn9F4oBB6vV7QNeKi4+QEf5DPii5WmSD9K3Z+iDq06JFH5zejgzWy6O+rczaPtm7f3DOl3XxHZyw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-PFumrKSdBGAKYEaEENnEy4PpZSZp8t8RYWkgUyY7QkZ+ZcqYEWc9dvzvoMlscVKb4/NoYrB2REkNtCu+zb+vcA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-Zfwi2Gesww6LjQwXT1jqHNIqhj2fLb0woea3RLKec9JvynzazLPu6G40GzrsZ4wLl00EX1aLbjUCJOp3VsO93g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-+q8UP3DgyTEGgAbYjhbTOZ2u7TzLENugBm3TWjotZiKEKR4xXn+ZifmVbQ2NZ/eTBNbdi6Fi+TQUAvCCjAwU/w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-YXCvPERukDSzy+drLG+9f3haR61XsRLM6hjk6eutb0LCew5pAc3Yh/DYR+W9qCmPwkzlkGYuyfDyo/FaLU4HEQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-7TCyhwPin4fR7Nf6ggP/ngDaZtjQEdkowM6NJUa5wAsLvz1l/WcIDaWDvaZKyrNnfrvlWecKbjOx0PxOgVOoJw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-N8fL0vrL6dbaDB0ogelbF3fEEOLGkQf95xSOEdq/Pi+S8esNNwrfrZfjlHZ1dOc0EUXZDgxvrJwTc5FazKYBdg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-RX/Fj9yHn9lXeHN87JgR0aAWCNQKcdk1omYs4yE6Gtbk7ORl1CXkq6VHy8UT9ULUC0wIo3+7OX36ciVU5nRXsQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-Hj9OwrnKZJbo2leR/Df+BfmntQCdnZbXoaZMtTpNzN7npHptiVaOv7bQ51hIC+qNp8MbvPeMbaN6rC2d1IR3iA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-lrDg2jv7Qyu7aD4COB0pwRGy7DgYgYRjDw6QRuRsbuMghTkyGYzEaQB78JwBqBYwqrXKQ+a+8qvQbpuRXpF42A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-goUOx6hlUIgfru/Nl4luQOW1NW7RjXFcnT1sQWfZfMcof72yG785+TvAjGsxbZAafT7Hqqle+KjVizkZvw8jnQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-joQATwpqLurBgrYw9GgJvyh4rOHK74x39RWTGnEimEAIhe+99uCO/OM8JcSzucfXnu3+lZwM/8Ki85kBpsJ5kw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-evYMyp8jNrr3+g1k52MqugUgrhyMR6RFVdMX0j9lBW+jWzRKmCJ4AEEWgYVLfX/p6XN60Vq5F+AvsxLmV6vCxA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-H+At/cuv8JLoP6XSmSSXWwn5fZ3ZJVjHbqXmi56ANSyyJxOll2/yjbY2H4WmyKQdBL0qJdr5zdf0XSqnqPdbdg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-fFvpxLMzN9K0tIPI4W+9LVC3WP0svv5KOPzhKSj5QOXTvOKsJTo8WMHKjjElg3kLTz9TqgtpQbgRcfzwqyOgaA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-pEHWmu67oLGKeg/fP3dzrt//L8/icvlSGueBufScK7/sITr9ecIolcqPqBRAYG740QM/p9hrTQhCVUppmhjjhA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-h3qfi/9UNZtgLOmuwa/AUDwjzutwrJ/CDUOcKeFjCut8vo5lNEBQ40AdCRDkwfMPRtZynnrRbHunsiADqEbAnA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-QzdaJymI2UF8sLTmGIV5KkWF6wEhX+T45L8uju5/oEDuufPLr7Up3d5uxf+5uh8+aqH8fwlu48Tt//LsYzKEaA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-2sb6VbprC5U83LBpd5DOPhvbBY1DtFBSvhCh3ppDAx4Gzcka4QAJZcYH9JRKt5EtTybdb0Pce6dRxRZ7aQqW4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-Y+8kJD2C8l4mejEFP5QneRsgQm/otzX+Dl4nVZLTbi05O/NEJkUmA/oWlluxE5Oe0ZyGi5/sfACcgzQ3E6nGVg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-hhj3jdVtsAh9jkMQWWuhpKA1za64OUsGD/mGiFl2KNpi1HGhxxHPwfT32ElX5GrqhmCs7l5iUszGBqK2uVYPBw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-ZUDP2dv59marjwXPSwIkZh7qtSsYlkFvyFSU2LvlVz9qUX5cPGJROdLgmIDj45vr9EcSDWUzyiDuuSR9o6Uxxw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-jWwOXYCQQLUMSKog2tK6ZJbnDhE4t0jeyc1vUjHfDHmEo3HQdHtrRf7fvJGroqMHK7novNOiGUllJ6qTAWnYFQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-DmTYpekFmL0mhyEBGU5yw2DScIf7LNKE3S2A/UwWSqpWTTdSZwHd4avbyVQPtD5IayqjeAGxmrVY02X281l9Wg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-nnT44goUsGrlCdNODhKEjS4F2GtcdSVCTpPkGWJaKaxcKngClTk99f9H3d4EbDugNKGNsQQwro3Yo+DFizwc/Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-Owmxgn5CZxwfhK6VUWjGAS1V00/9mrPb/VseFBsQXn2A/5brX83+jAhxVaXqEd6+k8j45DGJ4eutlBO6JPCDaA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-hcYIHXVYDFIIVEqf8gRLr2CEeJrqRJjY+I2jMeRg0JIk6cxQ6aNb6364QOVRckOrREiuGuHi1d2/zD/DiSWvFw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-YMP3AD/o8ZFRu1hoFnVbxgG8PEGDNUg6ENCu38GhJp/MDVNOT1r3G+0iuoI2lHvyhPv2qzCT6m26hZxqVHQxAg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-CFq8TbbTQeexS+e9YZiujvMDQkbSkGCxgCN7h2aqEQAXRSRy9kgApAuzLlQov2wLrSqXGLyp1BwpQFejBoqmtQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-zEiRA0vBh3H/siaL9g6mbzIvUr7UO6cg6EDHeV8ODiaV2qx5Bk/B8XR8OK3/gl61mSTn6mU2ObAG08aMpsyKnA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-jFasdaZcNTwFwclOKhNpsV09IyqoQXQ4iaOQIXQr3UAm3YQwrNtWguemHu1CrrivSBDBGjUkX1INmO1robymWQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-rgNo4vT50WUb3YwZZ81oJnUvD6kJVn7PGinLDTpQC+ayBi0wdJ6m8uRXpCTZ+yt4Rz6KR68LYWotMGdzAKfwuQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-3eN6DUdMKPHC46ANhDQv3Rg4saLj9zX7IvogtwQPQHP097z6m8mDhbMuuH+Fqa3VkxDc4pnDzEUnbXC/pvW+iQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.0-preview.1.25120.3";
        hash = "sha512-/OT3JlrxpuMsBeQMn4Gsj2y9r2d+gwsSC87cvvA4hRCbw3+PHBndvFfO5Aquj0O9MPNXiFhz/J7JRYDw47uIUA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-B/bP6DvMvk8YGbomVkdRy0tJuZsN/eLSQYy5INxaSINbNjaNjkg3Og6ZmL02Nt5PQtzz/bcAhPedrtGwEcIslA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-xQzXl7a5PmXx8PA26a3+ixE5JiEXJeIhcYv7dMulfixcWkRmTIiENIOHb8BrggTYHNo8ebRydSwg2EZYkfyCSw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.1.25080.5";
        hash = "sha512-oYeNNsXVwEbxlxYvla26qHjxoH/9CQRQMIrGKZHibznwXq4R6Q8yKS0+Z1zPGyYf4BC/01kjZ8pzwohfMS7DfQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.0-preview.1";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-preview.1.25120.3";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/33517412-d354-4852-a9e2-d6c7c83297e9/361cd00f354832d42bcdf19fd2094a36/aspnetcore-runtime-10.0.0-preview.1.25120.3-linux-arm.tar.gz";
        hash = "sha512-JTw+GHBZVBIchD02fjssu4/8RmSfLg2yVbNYMxY+XexrXfQcSXAQIoGvaM+NkSIi2xaN454hca85sMwWO8F+tw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0b4a8c7d-9b85-49d4-82b0-e2f45f1f61ac/4286d964b1600e1f3ee5d56f7c3b65cd/aspnetcore-runtime-10.0.0-preview.1.25120.3-linux-arm64.tar.gz";
        hash = "sha512-T5lvSP0hW2O4Ta8kpKsI3Vtod9q2vvDmw17JRRUrblsi3LqdUKwRmNWHYxPwvNDIAKpajMg+x2R+d0ZvdNrCLg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/de4894a9-20d4-4c58-a748-a2594d097279/bb332c7d3bbec4a642bee7ddc01b86f9/aspnetcore-runtime-10.0.0-preview.1.25120.3-linux-x64.tar.gz";
        hash = "sha512-v11PXB36Y+k39NDmuAAoNDej31xVsuQmw++wuNyXlLpwT11EaKzBMPDzuBrOPj1G7hGUW7xfNLvSnXtUw2Yw/A==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5cdd9ee9-cf13-4db5-bb3e-a09183be4ef2/3236e065b593cc2bb0bffc0c976f8e87/aspnetcore-runtime-10.0.0-preview.1.25120.3-linux-musl-arm.tar.gz";
        hash = "sha512-RleXs7jRVS6aRgkkgfHIFoJ78BxTLLi3quEQhwpOyfElAK25Htr7y78a5GM4pIUYRdVt4hJ01cbCtsyzldlRTw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/eedaffd0-7baf-49e2-9291-c9f57233d639/34f0f6b835f35306649977fe772e510c/aspnetcore-runtime-10.0.0-preview.1.25120.3-linux-musl-arm64.tar.gz";
        hash = "sha512-dwmkoFoOVqSlhQiQURWduEDAqNMHK7k2B2sccMicLxoLVHg+ZNdiotDdYba7UUTbrK1We6RpkhlsQQFKUbrczw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4fe69b65-885c-4235-9aa6-5758e6ac76a0/90be90ae3aab95d59b60f5889c5c6062/aspnetcore-runtime-10.0.0-preview.1.25120.3-linux-musl-x64.tar.gz";
        hash = "sha512-AVVkrZaLCRbxIqrrzHG9aACsSAF5y3Qj3KRUULnmHScSB6hr5afMDBYosef6SQYTOBnUe+qhgMp1wEEBr87puA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/87990395-a0a2-472f-a255-cc2639a9f5cb/06dd746d44a37da5325ab260dfa4e5f0/aspnetcore-runtime-10.0.0-preview.1.25120.3-osx-arm64.tar.gz";
        hash = "sha512-Q7JCQqV9pnNb7yb0oDmqHJvHlx9NLYuiiowBnaEzIH8YDWchROThIuJ0p9oRxl74ky6VRNZz1Qa54l7B3nQGFg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c7e3044f-0976-4051-ac6a-019982f4f4c7/58a188f7893c276ca2ab0f3b95c94756/aspnetcore-runtime-10.0.0-preview.1.25120.3-osx-x64.tar.gz";
        hash = "sha512-WDO9Z/HH4rFqO6yrZslMIKPO4u2WGceVTmvhZLgCQ47vYC1K2vBXoTxym241f/KekjxL4WuFKDYTKEi5DCLtYg==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.0-preview.1.25080.5";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a2280fc3-6358-4f89-8671-3d3535b3e14d/1e3ec98a6c92c9494e7012b80565b886/dotnet-runtime-10.0.0-preview.1.25080.5-linux-arm.tar.gz";
        hash = "sha512-jpHpZerOOsG0cvjZ0sulFTdgbLCumyJF3efy+dlfhmCADLYJpxUrPv6x4BZjBwyARU5hgIkMy4HWUz/MiR0STg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/67154807-282d-4a26-9fe6-16e561b763e9/1d556e1d17d9157dcbdcf09f1c523df8/dotnet-runtime-10.0.0-preview.1.25080.5-linux-arm64.tar.gz";
        hash = "sha512-hA0in8GTIgk+1aGMEjtaMi6SytJpJr23Ce44IHaGSp6JpN0OzBPl5IVCsXMuvRm6ZcrRwbY7lCaNOOeLvmtrdQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/527fa5e3-8b4b-482e-9c1f-c3cbf8cc0edc/259b1cf466fa1da69dafb26ef142b4cc/dotnet-runtime-10.0.0-preview.1.25080.5-linux-x64.tar.gz";
        hash = "sha512-twTf7Qg9NiMCTulupsuP9tXX4db0OiextHUKiRk/ZKlmoyEbcfnne8dgFTLbmS3zjDTR0VQvBgCCrgENUyQ3qg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0bb2df4f-2569-41d3-9543-f23cfbb25ce8/a64254fbc283ce409edb78d001561517/dotnet-runtime-10.0.0-preview.1.25080.5-linux-musl-arm.tar.gz";
        hash = "sha512-uQfZdISWYmbCZzL7thQeu5FL6CJYn+2tJq3ZaArW4Nx9AGhQckHA+64SSp9KlXGDgIA4fiHegYM/xzmb4b3WiA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6ecc182b-eb3a-4d4f-ab75-5c6c565d643a/70922b6f9f596549975d0c6c7672d558/dotnet-runtime-10.0.0-preview.1.25080.5-linux-musl-arm64.tar.gz";
        hash = "sha512-LMP3cV722ZhttzN2vL58bNu596WLQ+e+BRwu1Ff378JIo8Tch3OEZ62ZqCyjhe6lPryK8RwYkA9fmAyLdtmkdQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a580cb7d-1394-4571-9779-b62520571fa5/0ddc6d2478352d792caef0a21c8682e8/dotnet-runtime-10.0.0-preview.1.25080.5-linux-musl-x64.tar.gz";
        hash = "sha512-k2OKXnZrWFmuWOw7pd2BpgoObi5CZdCbG9ceQphyFt7x6Uqhw5jjPSC69rfAIYGM7hERc7V3H/DOK89WzJZMAQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a51a8de7-b1c0-4453-913b-b7421273ce3f/fef20f679bb688529545845a64f7ba2d/dotnet-runtime-10.0.0-preview.1.25080.5-osx-arm64.tar.gz";
        hash = "sha512-dOphwWoG+GxniNRsTXVyb23Vf75MRZPv9SqLFHL9+AWr5hgwhz/T70F4p1I499z994e3HjmoQV7Q9s4ExLoeQA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c0eb2952-c1e2-4d70-bdd6-96e7ff3f1350/efad700ef7526e474ed91611c1765272/dotnet-runtime-10.0.0-preview.1.25080.5-osx-x64.tar.gz";
        hash = "sha512-bqHaR7YOU2GWT/95ufo9zMCHyXc9NCw03vfuiY6vben0baZmRIR9mBYV3t85aYYQ+FDdZPIJvUQQ4FX1Czt+CQ==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.100-preview.1.25120.13";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/421388aa-682e-4ac0-b001-235c68ac75c6/2823384aea24f8fb43d0e8cf14b4c479/dotnet-sdk-10.0.100-preview.1.25120.13-linux-arm.tar.gz";
        hash = "sha512-06dnE4VQJryxMbl1lnUOJqQxgL6fh1gRIIo7G32IyB6WzHael99Mc5ejuqzjCY+EioNF32VgcDrOdl24shCS2A==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1889d4a2-7d5a-4048-b53f-b47ec6f73bbe/f550d0103110905cc472afa3ecf4223e/dotnet-sdk-10.0.100-preview.1.25120.13-linux-arm64.tar.gz";
        hash = "sha512-ZFthirf7zOOPgrLKml+raxF0LcnKU/S7ZWVNvoOF4Xia7QNBYkNq+ZjFnkGLUDFgfnGFbcOISHF6dPjzKS4MSw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ed3f7a1c-0aeb-4bff-8f93-db1b48c13dbc/dbd62e4564414b7de38e32ca47a0e9e3/dotnet-sdk-10.0.100-preview.1.25120.13-linux-x64.tar.gz";
        hash = "sha512-mGh8uJhZ/hhHoMrmx1LOIwkjHl7ybuUoWJOltXlPv9Ud34UQ3rX3AOopjO/9nLwPnybJx7TZAESoK90rmKv8xA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0a51b91a-f741-4903-8d01-29d81817c839/549fb11b7fc5bd0859adbf47f229dcbb/dotnet-sdk-10.0.100-preview.1.25120.13-linux-musl-arm.tar.gz";
        hash = "sha512-NhxG/rBTUNB8lpyIzBqCEVLLIVNdVEgXx7rFSRS4TVJuPlqmQvucxdwzHvAIuyBROIQa0iLsO5oGuNCHQfrpXQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8044b967-d629-406b-accd-6fccc09e9ae0/9d67c958431f0eb0f45b3c0f1bff81bc/dotnet-sdk-10.0.100-preview.1.25120.13-linux-musl-arm64.tar.gz";
        hash = "sha512-kWgHEHze5WH1MNOT2Awfw75VCZQ28yTvA9KpJ5Kzyrffn8PMyHxYqtVSAjL4B94sQlivSiTrE3FcNgzc9U76Pg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ece436cd-7c74-4c96-8d7b-bbca4f3f2dad/d50fac6150ce404dbb6ba7d779545f7c/dotnet-sdk-10.0.100-preview.1.25120.13-linux-musl-x64.tar.gz";
        hash = "sha512-NaLOk7p/OaCP0XcRiqDM/oyQBVuN+Y0+E0BkSpHD6pCvwCAb/7DOtUiCMT/dnTqwGsI9b4zLPvBnChr4Jc0yVw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/22d09ef4-cec4-48e7-be48-e105c9037dd4/33763054cbe2bbefd7d59c1d66e67122/dotnet-sdk-10.0.100-preview.1.25120.13-osx-arm64.tar.gz";
        hash = "sha512-XpjbKsqs+z6Rq1b9NppCJYcGDNTN87ZBG8UhTVm5hRQsRZ9lDqa2O2r48f/9L1451oWxeVCBSosTHlezDhwvSA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8462c34b-dc1e-4793-aab0-449bd1419d1c/bac3f5d229638e0d8600b9d4b304c26e/dotnet-sdk-10.0.100-preview.1.25120.13-osx-x64.tar.gz";
        hash = "sha512-X2C9WgE+Wc+2dLfS6TM7TojYvIZF6NGMynUeNWKGmG83HZ8hdnX3A8hcUVFZ4PdO9U1g5cf3F8HuRpp2hKV/XQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}

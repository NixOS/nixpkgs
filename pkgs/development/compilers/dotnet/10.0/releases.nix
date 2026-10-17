{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.12";
      hash = "sha512-9mmNHtEqsLyn7N6HFgBnMzavxii2O+lwCHLPiWPw3YjeNjEkmY2iHecaM5SCF0ywuSJy/5cUMm+yIcXkajC2Iw==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.12";
      hash = "sha512-fCG8AplzhdByuZbdL+cdbxdwkLaOm5SQEyhIczrsvdhD3heFAXmSpKYaoePyZKcgtDO9e58sxEUq49s2xkBglw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.12";
      hash = "sha512-T9zZjc+5Upl3NgL5GYurawa0yAmg1LrqwJOM+k/UaqGto+gbtdg+cZlkHmAER+nazXJX2SyUsc9UN9bXsHIt7g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.12";
      hash = "sha512-uN98mMdrujRLQdIBUdx55aTcdktf24k4RP39uJW+BSR9MctOk0Urpmi+svP2Kj8w7YsSQuBregxTsREl/Gm6KA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.12";
      hash = "sha512-qeOTK9DRbWx4/eebXG1v50ykEEmD9Uvp8J1iCFqnz30Wg8s8vfPd2tPpqae0wMnSYmdvKCmTCEg6/ZazSsulYg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.12";
      hash = "sha512-opT5P1p+CG70xGaveTgq3Q5OZKd7MZ0Rs10x4Tewl6bcPbu4SLo4F0n6RBCInvBKxoR10T11+X0M9dgjKEfucw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.12";
        hash = "sha512-uAZJJK0NG+LgvW6yh4d4NcMRgfUh50mdfdpM7/u4Dt3E1XiUjH6vPXTSl0FCisLEpJNouggLwyUhH7XrUQ6vpg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.12";
        hash = "sha512-5AlRS9Ur+GFEc7yio6AjDgZpaHS8tTdQeGWCVrd/aXI8l83+Jiy18zXTkF9TjSr9pi82g6HNlHwMbpiCIes21Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-Bj8DnDfxqaZuKsq5JrkgNlgpexNxM1omyqIVBb7PztrGPvzTO8vWMQ3qvyJc95P1xdPVuukV6I8td+v1S51wFw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.12";
        hash = "sha512-hBrbpFloNh3BlCDLxPff3ElYmGUuQM2ZTKlYRtGXYak9e+0nDMSmtQcxApMf06f8M4mGyEsGCSscW0BnuJuE2g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-EQ+HtSVgpCYFcKjcQPDhQazwnuy8AeeSoTudz65Kl1/8B7U5JDQ6tmV8uFhT94tXMnEs5XMoaYXcLOsBcgf8gg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.12";
        hash = "sha512-qtWP2QEN0FKzkEFL8bsLwgnM91F//kZ5+lEILYKWI6ApnQ8NeVFePgycZSW+OyLFbmGZ/yXCnVQ2a0DKUAUxyQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.12";
        hash = "sha512-gVS5PyGXXK1vvHoGSG6NBnS+ApD7VzWdhppjLrK58iD91b9pDxXuxpvCM+rFw0fzx9ZebDU3rqujkmE8PKMmBw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-DJYyA4ir3z10t4cVWfUYnohpnIHygRzD7DnuShTUL3gNPwUVCRLr0x1FmhWK9CBc3RLF+tbGuPJ0VjHhx946Xg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.12";
        hash = "sha512-C4lL7OfBZiG8GLYAVahA1GfQDiVFT6CRxFTJBSUnZCZSMobcOcwHxVMyJ+5ALYyIAGO/tG5/3SR8X/uURbEJoA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-464y9TftBThKbt1bqJ99SINFQYvp+5ye7ppeSurF55i4QsaX7xm0/05ag6Vbq6CaFriAr3EqX+2G8gkbuAGcKA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.12";
        hash = "sha512-Lsw9zALZkoKvYWMfMbNNcCNH5UcZGfi60Dylr3A7vkUIbHDTY+c0IFLO9I6YKA3pBFCVBeoUOoQuF2m7N8QJ6w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-YXd3x+3Wk3Rf4L1Lk1cCWNuHj9chmQw9iHy7hg3OTGi1WSvH7VVZiOiMpg8GXzGjC5aUwwn0vMVFv6ouyRlSPw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.12";
        hash = "sha512-55sgYLEBsiApC4eMoTXCeqjGhYMtuViG4z4xHFUv3bo3eq0ZxFNgscRMvWRy6E6Awv6dviSWXD3Gs/sP2eJvSw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-K34oso00OhUR1qTIF6l2s7Lf/ey+6wTFa+bmwxp5xjou0/r/DbKV2IUqRvZap6twe+dcRvcXjbB7zVNZJ+qGxA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.12";
        hash = "sha512-f4+eWTA0oWskBht+GgQE3tJeJU4X8ZfwavdiWBz/WxEFif4KU1sydVgX69W2WCPl88olcvUHA4be3Aqlfa3VAw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-FVbUgfWSDvntbp51Qp60ChcGEikJ6Fcp1I69metov7xHcyrrwMuYSbFX+LhZLnjHYvxXkWOwPW9ylnl+P1AB0w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.12";
        hash = "sha512-NKyVpSa5daiHs4SW8bivy3s8WNwZn6JeEDIdoboxuaO1n/031d4gwa4Necn78ZWXj94DTJEYAijfinGVufJEAQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-OHXVbpQEAm9XwbGgZzxyK1SFNAtpNCLHyeoRj0AwG1HtFzhx7lJYGAgN6CMO4KxhR8VuNS1NqJKVMrOzlZ1oTQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.12";
        hash = "sha512-sRWs2J7l5qn89lBwV6zz7wHA20aOcfoDjY9Vo2ql0IDuryZRkpJi7HK+ZKvvaJGszO4ui63ZZq+kpo+FZRgwCg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.12";
        hash = "sha512-sjIInStEQYmQTo/tSbcsL/XOqqCe60AuOSUapCp2VMC0QYnk79pRqb5O5hN/rOn54/rRqVDV6KTqRAZZTW4w3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.12";
        hash = "sha512-hpadurqmVc6QXkeFFDoxBGC5hY7n0wpERoVnq7T1L+ZSASknVTztnTW0phrRKIyBeVQTUNvpOodoVuKTMMKGnQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.12";
        hash = "sha512-2loLULCR0o9BHT6z48Egin7qnsFf0DC0VTVq37/twAsQeKe7oFfa3BvtzFpRz8jq3mdPp2xPbtzWnlzzRs7E2g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-BQt9ree08qIUR8pirirmaMEGzftCSzcvyed+1pYucDlVdjS9X9s20dJkMmSbi3MfHgwc8aHyw5B7DxniHQ09dw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.12";
        hash = "sha512-dbD+IapL9884XPBNGdfP7XXvpWkwE0MiMZ0DhMJ4P4aOG4y4l8P+t9i3vsrnQYYkB6D5n05AQgMNuj3WNKVG/Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.12";
        hash = "sha512-qUics32CIS7BxSac3U+LlxOaaIRDtSuwjUARAS1ZPoLmhETD4Z5FpEE1GQxzKqhlK7IId0V9HuaU6PCWFFw6OQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.12";
        hash = "sha512-uEj/w3++nHnuqUu0yVd5Wyd5crjQ9JYGuWRxi8Owki08NaDEv6mM1AwPGkp6+eYibpdSNQ0NPwGU2GJXo0PJ6Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.12";
        hash = "sha512-wi7jZfGEVTuajiD5Rx/RL5sGRGcHn5d6UU6o/H6IhexDHlVpaPGt5R6JicIcEEietKAYEatuMMzsSnFI26DIbg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-7YvnFu73g2hgSkc0aLmOJsdoXEDMOuHnRfAJUmcC53kyuQKK1q1YlBACZVF2ssXd5Vr/ayrY3YCKurMe3L1vHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.12";
        hash = "sha512-bTd89TZqyCMjjJMK1apRHrvWtEklmalD16xwXEesxjk9nUlZPGQ63QFnHhH9E8GfXKB0jFrznAJogNDYdeef3w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.12";
        hash = "sha512-M3cZRbtrCjFV1aJ0eA2MbIBe2CB3XO56dkqBoRjIyhAKo3luCzk7AqStyr5u4/7an2/SF+6ejhazWtiAcdTlsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.12";
        hash = "sha512-toj0lPRN7oDJe02OyTYDBkRW6mUWRn8LeUQWA7o5Rjnbt+7eJUB8ATlwKubVqDYnuOIyAkQMoDwmDC3gdB1yZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.12";
        hash = "sha512-FWJ8ixsfc+snzowYyAUlRGHehPjH9xtmLg0owWDV1Ju9dUeZf+OKuBagE+E/flME5Hhx7rObgcSVTXQak/wvGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-I5kU7+jw0qfZig9MdvGV4cXNgqb29/CaWZ0XD/ZmQnAw8o6n66abkmguHROuJr6aSK3LIkdnMOdWsizh4S7syg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.12";
        hash = "sha512-mgW2qXcts+ADITMrHQKhSc+OBZq/AjS3z8ERazD6WIr9AxoDwlVIDg+tf1a7f2g6QgQ33ZqFKPOSOTRLKusAoA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.12";
        hash = "sha512-VUseREdbZ7Os1MggOKzVuZgtzpHUmyGo8cLvvv+Mpe7dCJiiZgzMouyy8kWD24kWFzOqldKlpLT44nVv/zjh5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.12";
        hash = "sha512-6IZ1+8Xwp8NFJTD7+zlOqEn4byoEKi3s37luENSrPWlydNttWVVn2Y7EzZWRyphxuMLRiooW4nBQGQI5j+ohmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.12";
        hash = "sha512-kPTdf2SlIZxC8xYUOsRTWLgdDYXsRTUR0TY6S41mVae23TEPXtNZK5LcgigkVLrAqhCKbWRhoYlXHogOTT4DWw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-H4mu1lQqKaPgX8H1v9kcrf5PAzgEtNLSzrv8rD7b3Uc3sGVZm4AkEmbUMqJZBoS58t3YscMdn+8VCRlpeybqQQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.12";
        hash = "sha512-57dDOAdArYDhxJ4ehHV17p3xAvQkHPUN/M2iziRcaFtAIW+o5cJvf1LS45pvMbEwCryHYegAnfzqfXFC7JjHJA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.12";
        hash = "sha512-VWF3xkGqaVW2Qix7De0VzG/oy46M9l2q6i2VDZaD3bP69R0wajH+scwFJ2gQ1oU5lO8l4lrBKAq3kVe0sK249A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.12";
        hash = "sha512-pIUIzTMo+8KXEKmzpjiyJQMP1kFyoMtDcfqZIjywVNYFbghICddGVDvX6xNsN2E8FDB6SZZdEYq+vP/JJhVMQA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.12";
        hash = "sha512-y5h7q/0H3DXd16aSY3o1sR/U4HFwIiFixxLnmFqF3YRcyaZm1CswrSTzN5BZsrMDWP4fRZZirxdDZW3cx6RVYg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-oRLGX+AlNfAIgUNeD7siFR17gmg8y76LGckZRyvy7GRyK6BwXmqP5qJiAp1MB9yrr8fj3Lc6DoAtdZ0K2epptw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.12";
        hash = "sha512-QDwSSrv7J5Tj2HV9Hxcf5EsWKyVkiz2nKCf9JeahH4v0owW8VDQFmZDLJogLDvRl9FGG8S0m8qkLl53IorB4Yw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.12";
        hash = "sha512-YpB1BDncy5q89uAcKo4rKeyZkqTbGdJXQfssRDWdBwhZ8ceLvT+I5xGZdCMjKgEDJhNDsAR5Ik7t6rWYz4X0cw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.12";
        hash = "sha512-YIO8tBueBNk9v9H6wxqZ5/QQgmw7HEx2aP09v0JYvbNHylCig+Fsiyu6qJ7Lwz0mw4B1XFYoOkhpa1g6B/s2OQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.12";
        hash = "sha512-av1ZPsMaKAIDfy1dWgoukHBFSdTToYpvppQRo277+/Q9rjzZLPGxVcwd9H7vlDIKdZEcsBs8XNEnfsMrAQRQdg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-D4VsjRUP8Lm8E7g1Zk0Hb84Q2H0e3uWxR07t7PpDK+hudWBgBYsb+VUaGbVizv4+ux3eogJPGt0jX8Ml+RnEog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.12";
        hash = "sha512-KhTMjQCOg0cxbPzpdjRKAaTLdK2GvoXpx2ogsmWDXS8xV5qEUCJKIrI7dpo/ufA7llIEW9N9dMRgHggbSm6GmA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.12";
        hash = "sha512-yxiNGqHQPwU5ecdxXX8eI07UaQ596TQvydUx8f93p3WF2vJyynw7U9zUK0QspzNix2NzmNxMouUjvXAIO+4BTw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.12";
        hash = "sha512-2sYBokxR07f7uX4XyVUZkv3B8319NtJfAspf2iauqo/HrrTu7jRx5bayYwwtohdsSi7W5nzHNqjYW/t2UWi33Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.12";
        hash = "sha512-8rDt9QoxwXsA6a0tVl9b4fD5my0EZtXvJndCEFESf/H5hSlqvi26RBwfnvyiz3b8wS2pdP8G6H7xqdRJbSVkwg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-qVxNa/9CgDlX07wRZm2sO0LnR8snfvg1EVlQU3HYmmJritq55a6D3TXTifSmb3G/JSUmwhu0AA+vLrbs8D2AqA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.12";
        hash = "sha512-Qt7NCMotrQFrpukryPBpKeF/AawvptJv+v+c0Q3L29Y/ptFO8nFor+g8xKasWq4XNLL/hT/x+QBC7gacjeiIUQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.12";
        hash = "sha512-+atcf2Tu2z6hT+MuJQHcHsysHnbw8MS4flOLaPlzhhts6PygqK9g5QDOrSFjOsMoLurbccyr4MxanIP0UEGpkA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.12";
        hash = "sha512-YWj0a7N/Le5f90ObETvI/TBH8JhNG/Ke2euy1Cu1b872T2G3FWNOfzNgu1zKoSPuKUPr9qtDL3bDRX2NSw8q8Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.12";
        hash = "sha512-iPpHFMcrH8KdkNomgTAX/T3SoBBTWb9iWVIFhHqFfU4lwXo67QK0JbMA9kG53i1VEYMrdbhQwRzoHyAKF4voBg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-OaJPz4903ojJr98flHOKo9rVqK8Brb/GJSZBlKkB00Y7MTQRI2JcKShcQnbOPuIhKooG2ydLU5bq7kBAZ1o7/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.12";
        hash = "sha512-EtH/Fy2Vule8tBGJczbLBItkg3RcQc7o0Qg6aRqMWDEXpLc/bDkS4ndZ9bFgo8IKA+IT/MghRJgC7c+V8CEjug==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.12";
        hash = "sha512-PgvTgjE6ic5JQKmBeTmSd8h0RHQvnL89cysBqZ62tf05ZqwD0ZfVnwK2QqQ8mS+Rx2OVQ5YCuVZGdTUC46agtQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.12";
        hash = "sha512-gLuDYSIlarcFPsw0e8iTALP+EaJ9mo01z9OjrkZ1+4WiArtkN4v29HXuossmUmvXrwVqt1clL4aCeOiUY55o2A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.12";
        hash = "sha512-ucOvZlk4/l8N2NhCRAWrX0DX4/dBFC9UFgZVLAOb40WzokltLBbNYblIpn8tfz7qkWsQhTq08KYa5vwH2kAiPg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-w32H2HbDUs4FI74YrL/31i/eJX98WiMA3TSuNPE6bwDv03tVoLxVqZlWCUT4RWx2ap5zIEytd34reusJBQfOxA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.12";
        hash = "sha512-Ap/dFLb0kI/oIoRWGHJXWgjT75F2qBNn8t9cJMT5IO98EN+ae3hA0uMNkPj6p5FVmsRkno60LJXhpZbD7XaYnw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.12";
        hash = "sha512-n8qSkT3KkkXSpu9UU748wzEbrDwLOJCkOGxY0D/tvWOwUXUbS2qRk5icYG2SukR7+i1eO8YF4sOl+ivbohhRPA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.12";
        hash = "sha512-M8J2D1k24eswYJ/DaJdHYbwzHrcg+gWTv5L58FDG2R1n9nOiJ4MWCrhMFtZzbowCwQBmztbAbM7tN49cuqeFiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.12";
        hash = "sha512-Oa/LIiAy6r6+LH+lGjfEkcaw9FZ5ateIhDGXG47vT2icruVFQmA5jOD/r+SRxWWJGzXnOvxnWFo+TEvemVcQ7g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-mCKSE0T5AwsX/N3KwIe4LfXAztVtQVPV8AwRqjrw/cmgggmUrDtjqILf+eZSrAXvlTTButP9fh6ppEh/graAhQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.12";
        hash = "sha512-vFbdHRG0pJh0zBLPpm8BY/oaNT+4TYFY4zbi63eevXrgqkh9ZgvIUEPIM1iaM/NI6mZ0zxv2F0T+GunTgWjpyA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.12";
        hash = "sha512-kUHsEUNQQFHzAByydGNQ8Mv/u80jvNB0mrAPpUBfDU0Czg9AcluUdEx4hW0p26/GovB9A3WVr9T2rM+F+w0G/Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.12";
        hash = "sha512-4zc+h8W0AFpTHr6D1deA2ULBdniLneiSbSGCxClmcyQxM6l2e+XKaH0QEFvuCg4SVVE7LFgQ9d89Wt6E5MDFwA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.12";
        hash = "sha512-8p2Cfiig3XwYVSkURQu1l9LOMO0CgjG57R81Ppae+UpKiKSuPKuaqpseaKKIOiqfPQKkZBZontSe1RT382tuPg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.12";
        hash = "sha512-va1ABgoJ2VHN9RAwWiyaIYYbw8ZDTZLgvZKnxyKTx+nhvrr1afgq4nlY2YVBfw05nDaz2QyK8JQFfWqnWKW4CQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.12";
        hash = "sha512-pmNDOlE6alHD15W943qTdcBLZFuFAK/SxXwdpjYbaJmUD3tcQUoptyR0AW5zm3QJLmpqLnqznVSDTE4QTSZaMQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.12";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.12";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-linux-arm.tar.gz";
        hash = "sha512-kZ/D+dwhWWpOtgRexTiZTyDrVN+xLu1oc2QbGGrGNSmWEYhLTsgs9S1H39jVtVnHQ9NrcCRkvcXh458iMO1Czw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-linux-arm64.tar.gz";
        hash = "sha512-m6mIkFeouKg3EJnx/JnGcQtyP9A1mUEYO5pQQLfZ+38DvAa32tEAlp9D+FLaiLbYQ/bHmDyGaRWUYSBDIz8uAg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-linux-x64.tar.gz";
        hash = "sha512-xIn8Op3MhfJPLVLpqBtG/fUa/8ijYNAI29Xjt85SSWmtxKVPVVrRPim4IvWe0crpeFYIy6wigvLJxP2kXCHH0Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-linux-musl-arm.tar.gz";
        hash = "sha512-zP8m1FlDVRHvVJC/LRi7TiN0V2UA87CWxExkIO6/dyw6zf0EjaINR6zwZf19SZMptQQBaWm5Fx/FC7DGY9h/+A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-linux-musl-arm64.tar.gz";
        hash = "sha512-HQp5ZPSjD00Vx1zDDLDSLm8UcDGvqlO45Btsaz9/hnDcpyCOuUSb+7MGvAl7r9twW4Q//xO31YVMI7dN2YWt/A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-linux-musl-x64.tar.gz";
        hash = "sha512-Uq7PVBFURQ4JhWQEVSpNW5A2UEctzcXVbj9kWRF+iS/CeZ0uAI//AR8RYTA/QU24636zy2B68OFnIKkbLEvtVA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-osx-arm64.tar.gz";
        hash = "sha512-vdmi551b2b10muSGlJbqQ1uURFvCyI6fv7qPfljOb3yQGsaIVdbxcOCxjlFPwPopluvPoOcdQW4RotZBboI1IQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-osx-x64.tar.gz";
        hash = "sha512-rSN0TYzwjYAOYFy+cPaulyhrXH6eInpztrkhPdzUY7VemJo4mHedm5aBFq6cFPddxU4VPgrEVq5wF3TjpLaROw==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.12";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-linux-arm.tar.gz";
        hash = "sha512-4VcijJxpOH4tCxBcxhdejEIS7A5NjZyuK+yI6mnVQB4kqW5/Nr3u1o52X0lAc1tG4S5oa74NQIDeTwErz5V0Pg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-linux-arm64.tar.gz";
        hash = "sha512-rB4AkDkQhbpwx0V62qqPbMINwha5s2i0InpCfeJxcI14M4DHuVW3vkiX/ySEn75cO37Byxw4NFpyXemjgSKA6w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-linux-x64.tar.gz";
        hash = "sha512-WDiP3eTxO9cDx6b33vszALF+Qrpf6LylAGb4D2SsdAZiDc37Sswe/3mSdQyMxc/4Np3RLQlzDIqeh2DWAy9/bg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-linux-musl-arm.tar.gz";
        hash = "sha512-qcdage30x4l1pR8BsaKwUX8I6G/NrHW1OUso8cDRVp5dOWK1+acXk/+SnSxZ5TQAXehAeYQ0+OKqhIbT8bAROA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-linux-musl-arm64.tar.gz";
        hash = "sha512-jzaan/hOBrVwuRuvEQONZ1GiI1ABMUdwgPA+Rzu108ddOfO4Olr3lJ74OEaNfhvrRlKc1lRwLk2Y4X40tAOHRA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-linux-musl-x64.tar.gz";
        hash = "sha512-ClMvuLkf1+NFikFKg7mwqJBDdPtFnejfipiOgawaxWuPVvaKYoA7d7mv7Vu966wLIapNAAf7xq5pAL5Ik7Tyzw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-osx-arm64.tar.gz";
        hash = "sha512-0bQiwq/stedBQwWEw+GIfV4PLfMhqA1JL90T2Mf5lXnw278040i8USyydvD4a0ZFQjoDLe1SgIt0q46w178qbQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-osx-x64.tar.gz";
        hash = "sha512-xQGTV8nY++MLSeyPga6FvlanhNi0t19HDpMVg8OeCCdzwImzl4WzIncKKYqwhjbGsw5pWiOX/DEQYPc8mHQ7SA==";
      };
    };
  };

  sdk_10_0_4xx = buildNetSdk {
    version = "10.0.401";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.401/dotnet-sdk-10.0.401-linux-arm.tar.gz";
        hash = "sha512-lKilKGLKnw3hB1pGjW5OMHodRGMJip6CZuZpOXCagSsBJuISzOfoxv6uaweNhsi3fgiIFKDjJTHtsNoKHOkMEQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.401/dotnet-sdk-10.0.401-linux-arm64.tar.gz";
        hash = "sha512-WKznPO1rQ2B1Rommhr37ijF/TabLi7QW28fQup9H5D48CfXrHxoc+qy9EN+VWNpIgr8qXhldarVqAsH592EC7Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.401/dotnet-sdk-10.0.401-linux-x64.tar.gz";
        hash = "sha512-Uci5ma+ejdmZjJ7cWUThmpB4iGIGis04aU4JiIkFTOjCPU8MXMz6Fr8YfQRFYjWeXuaan4rQu+kTupAxH7ziWw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.401/dotnet-sdk-10.0.401-linux-musl-arm.tar.gz";
        hash = "sha512-TbiKs/MXWoVNxEayDQLl8lGY0v0U3wasAEAb/S4xGdfauWrgnvmsaFuGp/xTx7GnLympBQV7qz/JOMGAdlSrJQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.401/dotnet-sdk-10.0.401-linux-musl-arm64.tar.gz";
        hash = "sha512-Aeo/C2c+8XRRQHVPkaUA7P038jQtd4mV/0x9+cnUFSEcckwNAu1z2jvPhY6QdPutv28H8AZ7WAcryhyrsxqoiw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.401/dotnet-sdk-10.0.401-linux-musl-x64.tar.gz";
        hash = "sha512-f1Gzn5IGa2lV/fY3ZMeZv6b31jaDiTr4lycGy9i8/125W3hMBvC9SkzUOeItF8df2PUdqZJGxGoxaz6cwIHHoQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.401/dotnet-sdk-10.0.401-osx-arm64.tar.gz";
        hash = "sha512-afZOsA3ARTmHVcRAsVIiXVRDAaNFoUahboalagxSt8lLLDMVIOl227gh8Y0xkwqvvSW7hZYeNRfgZlQUzgy8/w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.401/dotnet-sdk-10.0.401-osx-x64.tar.gz";
        hash = "sha512-M0AbSi2oVU4zBttgcuqFadn8xghQnCceCqSznnzEMto2MfFOfh4kRdZ9clUNGM5EqLvSOCp1aGetLtq2scljwA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.112";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-linux-arm.tar.gz";
        hash = "sha512-hNUia7Oh4RTHnpaue1rNCaYf8EVb8tRaoYPKtmL57dEYz9yI5Y34qfHC6FjoYjmWG5CPM6fX9ay7LQtyK+nMcA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-linux-arm64.tar.gz";
        hash = "sha512-KXN4s0fUT2Gf7IaJgyOJTxQWKdwKs7cCXIbwJaejHJjm+odO8sRz5zvXPPNwzOUVTfRxzHj6c0Ird1i06j9cag==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-linux-x64.tar.gz";
        hash = "sha512-GslJ39OSmFXjoQKlsS+EOWenhK0tkR38//ar34Gi54vM8l3cBVVH3gKzYTO/eSqvl/y6jbiqa1KsLgGLhpNdBQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-linux-musl-arm.tar.gz";
        hash = "sha512-WRUKDOHNuTKo1/L2RIjd8BvPNB9itIanbLk0JSjZSGJhp1pypmn03NFxR/ONNIFhN7uCfJHQrIfi008ZtKRr7g==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-linux-musl-arm64.tar.gz";
        hash = "sha512-SEoePzxFt3qMt6RQ3GgWWZ17H90CKHIM3MwiqQ+dDGYcxdjmS2d6akc0votn9sdfLHgxxvAgRgzr7Xy3zTnZ7w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-linux-musl-x64.tar.gz";
        hash = "sha512-UF+jYl73be1P+hJcVsQqjhUC7RiyYq8Kj1wIoaEodsiT5fs0WRPAr+YNuSFnpM4ZIZNfuREIlK/weqavVKfRDQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-osx-arm64.tar.gz";
        hash = "sha512-HP4Soa44PuFfpGNsFjDaeGGWPdxNBSLEEtY8kFcOqH0QHmvf973CcD/EKl2c4y5ztUWYQcKZASgnmgrmQglKOA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-osx-x64.tar.gz";
        hash = "sha512-gVez/iSjlD2lfjnaCFxXxDRd1M3vAAWJNbdTzs+AQLsCKkyTaO1BejrVDeG/iVCWQJpL/rrFXUZtW14eqPx1QA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_4xx;
}

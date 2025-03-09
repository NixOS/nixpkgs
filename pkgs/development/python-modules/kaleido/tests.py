import plotly.express as px
import os
import os.path

out = os.environ["out"]
if not os.path.exists(out):
  os.makedirs(out)

outfile = os.path.join(out, "figure.png")
fig = px.scatter(px.data.iris(), x="sepal_length", y="sepal_width", color="species")
fig.write_image(outfile, engine="kaleido")
